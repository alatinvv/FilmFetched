//
//  MovieListViewController.swift
//  MovieTest
//
//  Created by Tinh Vu on 11/29/18.
//  Copyright © 2018 Tinh Vu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class MovieCell: UITableViewCell {
    static let cellIdentifier = "MovieCell"
    @IBOutlet weak var imvIcon: UIImageView!
    @IBOutlet weak var lbMovieName: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbDescription: UILabel!

    var movie: Movie! {
        didSet {
            lbMovieName.text = movie.title
            lbDate.text = movie.releaseDate
            lbDescription.text = movie.overview
            if let posterPath = movie.posterPath {
                imvIcon.setImage(posterPath)
            }
        }
    }
}

class MovieListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private var refreshControl: UIRefreshControl!

    fileprivate let bag = DisposeBag()

    fileprivate var viewModel: MovieListViewModel = MovieListViewModel(api: API.instance)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movie List"
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = UIView()
        bindUI()

        viewModel.loadDataAction.execute("First load")
    }
    
    private func bindUI() {

        viewModel
            .movieList
            .asObservable()
            .bind(to: tableView.rx.items) { [weak self] tableView, index, event in
                let indexPath = IndexPath(item: index, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.cellIdentifier, for: indexPath)
                self?.config(cell, at: indexPath)
                return cell
            }
            .disposed(by: bag)

        viewModel.isLoadingData
            .asDriver()
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: bag)

        tableView.rx
            .modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] (movie) in
                guard let this = self else { return }
                this.routerToMovieDetail(movie: movie)
            })
            .disposed(by: bag)

        refreshControl.rx
            .bind(to: viewModel.loadDataAction, controlEvent: refreshControl.rx.controlEvent(.valueChanged)) { _ in
                return "Refreshing"
        }

    }

    private func config(_ cell: UITableViewCell, at indexPath: IndexPath) {
        if let cell = cell as? MovieCell {
            cell.movie = viewModel.movieList.value[indexPath.row]
        }
    }

    private func routerToMovieDetail(movie: Movie) {
        if let movieVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieViewController") as? MovieViewController {
            movieVC.movie = movie
            self.navigationController?.pushViewController(movieVC, animated: true)
        }
    }

}


