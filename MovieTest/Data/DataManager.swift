//
//  DataManager.swift
//  MovieTest
//
//  Created by Tinh Vu on 11/29/18.
//  Copyright © 2018 Tinh Vu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DataManager {
    static let instance = DataManager()

    func saveMovies(_ movies: [Movie]?) -> Observable<Void> {
        guard let `movies` = movies else {
            return Observable.empty()
        }
        return Observable.create({ (observer) -> Disposable in
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: movies)
            UserDefaults.standard.set(data, forKey: Key.MOVIES)
            UserDefaults.standard.synchronize()
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        })
    }

    func loadMovies() -> Observable<[Movie]> {
        return Observable.create({ (observer) -> Disposable in
            if let decoded  = UserDefaults.standard.object(forKey: Key.MOVIES) as? Data {
                let movies = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [Movie]
                observer.onNext(movies ?? [])
            } else {
                observer.onNext([])
            }

            observer.onCompleted()
            return Disposables.create()
        })
    }

    func saveMovie(_ movie: MovieDetail) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: movie)
            UserDefaults.standard.set(data, forKey: "\(movie.id)")
            UserDefaults.standard.synchronize()
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        })

    }

    func loadMovie(_ withId: Int) -> Observable<MovieDetail> {
        return Observable.create({ (observer) -> Disposable in
            if let decoded  = UserDefaults.standard.object(forKey: "\(withId)") as? Data {
                let movie = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? MovieDetail
                observer.onNext(movie ?? MovieDetail.stub())
            } else {
                observer.onNext(MovieDetail.stub())
            }

            observer.onCompleted()
            return Disposables.create()
        })
    }
}
