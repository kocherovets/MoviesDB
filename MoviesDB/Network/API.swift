//
//  API.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 10.11.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import Moya
import RedSwift

let GeneralNetworkErrorMessage = "Network problem. Try again or later."

protocol API: TargetType {

    static var useSampleData: Bool { get }

    static var api: MoyaProvider<Self> { get }

    func url(_ route: TargetType) -> String
    static func JSONResponseDataFormatter(_ data: Data) -> Data
}

extension API {

    static var useSampleData: Bool {
        return false
    }

    func url(_ route: TargetType) -> String {
        return route.baseURL.appendingPathComponent(route.path).absoluteString
    }

    static func JSONResponseDataFormatter(_ data: Data) -> Data {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return prettyData
        } catch {
            return data // fallback to original data if it can't be serialized.
        }
    }

    static func request<T: Decodable>(target: Self,
                                      callbackQueue: DispatchQueue? = StoreQueue,
                                      completion: @escaping (Result<T, Error>) -> (Void)) -> Cancellable {

        return Self.api.request(target, callbackQueue: callbackQueue) { result in
            switch result {
            case .success(let response):
                do {
                    let result = try response.map(T.self,
                                                  atKeyPath: nil,
                                                  using: apiJSONDecoder)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
                if case .underlying(let error, let response) = error {
                    if error.localizedDescription == "The Internet connection appears to be offline." || response == nil {
//                        HRouter.shared.showOffline()
                        return
                    }
                }
//                HRouter.shared.showAlert(message: GeneralNetworkErrorMessage)
            }
        }
    }
}
