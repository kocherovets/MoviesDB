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

    case popular(page: Int), topRated, upcoming(page: Int), nowPlaying(page: Int), trending(page: Int)
    case movieDetail(movie: Int), recommended(movie: Int), similar(movie: Int)
    case credits(movie: Int), review(movie: Int)
    case searchMovie, searchKeyword, searchPerson
    case popularPersons
    case personDetail(person: Int)
    case personMovieCredits(person: Int)
    case personImages(person: Int)
    case genres
    case discover
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

        var queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        var path = "https://api.themoviedb.org/3/"
        switch self {
        case .popular(let page):
            path += "movie/popular"
            queryItems.append(URLQueryItem(name: "page", value: String(page)))
        case .popularPersons:
            path += "person/popular"
        case .topRated:
            path += "movie/top_rated"
        case .upcoming(let page):
            path += "movie/upcoming"
            queryItems.append(URLQueryItem(name: "page", value: String(page)))
        case .nowPlaying(let page):
            path += "movie/now_playing"
            queryItems.append(URLQueryItem(name: "page", value: String(page)))
        case .trending(let page):
            path += "trending/movie/day"
            queryItems.append(URLQueryItem(name: "page", value: String(page)))
        case let .movieDetail(movie):
            path += "movie/\(String(movie))"
        case let .personDetail(person):
            path += "person/\(String(person))"
        case let .credits(movie):
            path += "movie/\(String(movie))/credits"
        case let .review(movie):
            path += "movie/\(String(movie))/reviews"
        case let .recommended(movie):
            path += "movie/\(String(movie))/recommendations"
        case let .similar(movie):
            path += "movie/\(String(movie))/similar"
        case let .personMovieCredits(person):
            path += "person/\(person)/movie_credits"
        case let .personImages(person):
            path += "person/\(person)/images"
        case .searchMovie:
            path += "search/movie"
        case .searchKeyword:
            path += "search/keyword"
        case .searchPerson:
            path += "search/person"
        case .genres:
            path += "genre/movie/list"
        case .discover:
            path += "discover/movie"
        }
        
        var urlComponents = URLComponents(string: path)!
        urlComponents.queryItems = queryItems
        
        return urlComponents.url!
    }
    var path: String {
        ""
    }
    var method: Moya.Method {
        return .get
    }
    var task: Task {
        return .requestPlain
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
