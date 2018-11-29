//
//  MovieViewModel.swift
//  MovieTest
//
//  Created by Tinh Vu on 11/29/18.
//  Copyright © 2018 Tinh Vu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieViewModel {
    let api: API
    let bag = DisposeBag()
    let dataManager = DataManager.instance
    // MARK: - Input
    private(set) var movieId: BehaviorRelay<Int>

    // MARK: - Output
    private(set) var movieDetail: BehaviorRelay<MovieDetail?>

    init(api: API, id: BehaviorRelay<Int>) {
        self.api = api
        self.movieId = id
        self.movieDetail = BehaviorRelay<MovieDetail?>(value: nil)
        bindOutput()
    }

    private func bindOutput() {
        self.movieId.asObservable()
            .flatMap{ [weak self] id -> Observable<MovieDetail> in
                guard let this = self else { return Observable.empty() }
                return this.api.getMovie(id)
                    .catchError({ (error) -> Observable<MovieDetail> in
                        return this.dataManager.loadMovie(id)
                    })
                    .do(onNext: {[weak self] (movie) in
                    _ = self?.dataManager.saveMovie(movie).subscribe()
                })
            }.subscribe(onNext: { [weak self] (movieDetail) in
                self?.movieDetail.accept(movieDetail)
            }, onError: { (error) in

            })
            .disposed(by: bag)
    }
}
