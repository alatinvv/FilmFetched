//
//  MovieViewController.swift
//  MovieTest
//
//  Created by Tinh Vu on 11/29/18.
//  Copyright © 2018 Tinh Vu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InfomationCell: UITableViewCell {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbValue: UILabel!

}

class MovieViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imvBanner: UIImageView!
    @IBOutlet weak var imvIcon: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbSubName: UILabel!

    var movie: Movie?

    fileprivate let bag = DisposeBag()

    fileprivate var viewModel: MovieViewModel!

    let titles = ["Overview", "Genres", "Duration", "Release Date", "Production Companies", "Production Budget", "Revenue", "Language"]
    var values: [String?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = movie?.title
        guard let `movieId` = movie?.id else {
            return
        }

        viewModel = MovieViewModel(api: API.instance, id: BehaviorRelay<Int>(value: movieId))

        bindUI()
    }

    private func bindUI() {
        viewModel.movieDetail.asObservable()
            .subscribe(onNext: {[weak self] (movieDetail) in
                guard let this = self, let `movieDetail` = movieDetail else { return }
                this.lbName.text = movieDetail.title
                this.lbSubName.text = movieDetail.tagline
                if let posterPath = movieDetail.posterPath {
                    this.imvIcon.setImage(posterPath)
                }
                if let backDropPath = movieDetail.backdropPath {
                    this.imvBanner.setImage(backDropPath, isLarge: true)
                }

                this.values.append(movieDetail.overview)
                this.values.append(movieDetail.genres?.map{ $0.name ?? "" }.joined(separator: ", "))
                this.values.append("\(movieDetail.runtime) Minutes")
                this.values.append(movieDetail.releaseDate)
                this.values.append(movieDetail.productCompanies?.map{ $0.name ?? "" }.joined(separator: ", "))
                this.values.append(movieDetail.budget.toCurrency())
                this.values.append(movieDetail.revenue.toCurrency())
                this.values.append(movieDetail.languages?.map{ $0.name ?? "" }.joined(separator: ", "))
                this.tableView.reloadData()
            }).disposed(by: bag)

        
    }

}

extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! InfomationCell
        cell.lbTitle.text = titles[indexPath.row]
        if values.count > indexPath.row {
            cell.lbValue.text = values[indexPath.row]
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
