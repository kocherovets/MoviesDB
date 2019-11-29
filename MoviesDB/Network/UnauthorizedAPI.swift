//
//  UnauthorizedAPI.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 25.11.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//


import Foundation
import Moya
import RedSwift

let apiKey = "5e0e50f2221df20ff3f08d3cba8b2b4c"

enum UnauthorizedAPI: API {

    case nowPlaying
    case upcoming
    case trending
    case popular
}

extension UnauthorizedAPI {

    static var api = MoyaProvider<UnauthorizedAPI>(
        callbackQueue: StoreQueue,
        plugins: [
            NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)
        ])
}

extension UnauthorizedAPI: TargetType {
    var baseURL: URL {

        var path = "https://api.themoviedb.org/3"
        switch self {
        case .nowPlaying:
            path += "/movie/now_playing"
        case .upcoming:
            path += "/movie/upcoming"
        case .trending:
            path += "/movie/top_rated"
        case .popular:
            path += "/movie/popular"
        }

        var urlComponents = URLComponents(string: path)!
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
        ]
        return urlComponents.url!
    }
    var path: String {
        ""
    }
    var method: Moya.Method {
        return .get
    }
    var task: Task {
        switch self {
        case .nowPlaying:
            return .requestPlain
        case .upcoming:
            return .requestPlain
        case .trending:
            return .requestPlain
        case .popular:
            return .requestPlain
        }
    }
    var validationType: ValidationType {
        switch self {
        default:
            return .successCodes
        }
    }
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    var headers: [String: String]? {
        nil
    }
}
