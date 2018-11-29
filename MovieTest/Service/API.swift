//
//  API.swift
//  MovieTest
//
//  Created by Tinh Vu on 11/29/18.
//  Copyright © 2018 Tinh Vu. All rights reserved.
//

import Foundation
import RxAlamofire
import ObjectMapper
import RxSwift
import Alamofire
import Reachability

typealias JSONObject = [String: Any]

enum APIError: Error {
    case invalidURL(url: String)
    case invalidResponseData(data: Any)
    case error(responseCode: Int, data: Any)
}

enum ResponseError: Error {
    case noStatusCode
    case unauthorized // 401
    case notFound  // 404
    case unknown(statusCode: Int)
}

protocol MovieAPIProtocol {
    func getMovies() -> Observable<MovieResult>
    func getMovie(_ id: Int) -> Observable<MovieDetail>
}

class API: MovieAPIProtocol {

    static let instance = API()

    private func _request(url: String, method: HTTPMethod = .get, params: [String: String]? = nil) -> Observable<Any> {
        let manager = Alamofire.SessionManager.default
        var parameters = params
        if var `parameters` = params {
            parameters["api_key"] = Config.API_KEY
        } else {
            parameters = ["api_key": Config.API_KEY]
        }
        return Reachability.rx.reachable.flatMap { isReachable -> Observable<Any> in
            if isReachable {
                return manager.rx.request(method, url, parameters: parameters).flatMap{ dataRequest -> Observable<DataResponse<Any>> in
                    dataRequest.rx.responseJSON()
                    }.map{ dataResponse -> Any in
                        return try self.process(dataResponse)
                }
            } else {
                return self.showNetworkErrorAlert()
            }
        }
    }

    private func showNetworkErrorAlert() -> Observable<Any> {
        return Observable.create { observer in
            let presentClosure = {
                let alert = UIAlertController(title: "Network error", message: "Unable to contact the server", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                    observer.onNext(())
                    observer.onCompleted()
                })
                alert.addAction(okButton)
                alert.modalPresentationStyle = .overFullScreen
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }

            if Thread.isMainThread {
                presentClosure()
            }
            else {
                DispatchQueue.main.async(execute: presentClosure)
            }

            return Disposables.create()
        }.subscribeOn(MainScheduler.instance)
    }

    private func process(_ response: DataResponse<Any>) throws -> Any {
        let error: Error
        switch response.result {
        case .success(let value):
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 200:
                    return value
                case 401:
                    error = ResponseError.unauthorized
                case 404:
                    error = ResponseError.notFound

                default:
                    error = ResponseError.unknown(statusCode: statusCode)
                }
            }
            else {
                error = ResponseError.noStatusCode
            }
            print(value)
        case .failure(let e):
            error = e
        }
        throw error
    }

    func requestObject<T: Mappable>(url: String, method: HTTPMethod = .get, params: [String: String]? = nil) -> Observable<T> {
        return self._request(url: url, method: method, params: params)
            .map { data -> T in
                if let json = data as? [String:Any],
                    let item = T(JSON: json) {
                    return item
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
        }
    }

    func requestArray<T: Mappable>(url: String, method: HTTPMethod = .get, params: [String: String]? = nil) -> Observable<[T]> {
        return self._request(url: url, method: method, params: params)
            .map { data -> [T] in
                if let jsonArray = data as? [[String:Any]] {
                    return Mapper<T>().mapArray(JSONArray: jsonArray)
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
        }
    }

    func getMovies() -> Observable<MovieResult> {
        let url = Config.API_ENDPOINT + "discover/movie"
        return self.requestObject(url: url)
            .observeOn(MainScheduler.instance)
            .share(replay: 1, scope: .whileConnected)
    }

    func getMovie(_ id: Int) -> Observable<MovieDetail> {
        let url = Config.API_ENDPOINT + "movie/\(id)"
        return self.requestObject(url: url)
            .observeOn(MainScheduler.instance)
            .share(replay: 1, scope: .whileConnected)
    }


}
