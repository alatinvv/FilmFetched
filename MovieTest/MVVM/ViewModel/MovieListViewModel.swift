//
//  MovieListViewModel.swift
//  MovieTest
//
//  Created by Tinh Vu on 11/29/18.
//  Copyright © 2018 Tinh Vu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MovieListViewModel {
    let api: API
    let dataManager = DataManager.instance
    let disposeBag = DisposeBag()

    // MARK: - Input

    // MARK: - Output
    private(set) var movieList: BehaviorRelay<[Movie]>
    private(set) var isLoadingData = BehaviorRelay(value: false)

    private(set) var loadDataAction: Action<String, [Movie]>!

    init(api: API) {
        self.api = api
        self.movieList = BehaviorRelay<[Movie]>(value: [])
        bindOutput()
    }

    private func bindOutput() {
        loadDataAction = Action { [weak self] sender in
            print(sender)
            self?.isLoadingData.accept(true)
            guard let this = self else { return Observable.never() }
            let getMoviesObservable = this.api.getMovies().map{ $0.results ?? [] }.do(onNext: {[weak self] (movies) in
                _ = self?.dataManager.saveMovies(movies).subscribe()
                })
            return Observable.merge(getMoviesObservable, this.dataManager.loadMovies())
        }

        loadDataAction
            .elements
            .subscribe(onNext: { [weak self] (movieList) in
                self?.movieList.accept(movieList)
                self?.isLoadingData.accept(false)
            })
            .disposed(by: disposeBag)

        loadDataAction
            .errors
            .subscribe(onError: { [weak self](error) in
                self?.isLoadingData.accept(false)
                print(error)
            })
            .disposed(by: disposeBag)
    }
}
