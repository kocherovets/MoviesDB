//
//  Movie.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 25.11.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import Foundation

struct ServerModels {

}

extension ServerModels {
    
    struct Movie: Codable, Equatable {

        let posterPath: String?
        let adult: Bool
        let overview: String
        let releaseDate: String
        let genreIds: [Int]
        let id: Int
        let originalTitle: String
        let originalLanguage: String
        let title: String
        let backdropPath: String?
        let popularity: Double
        let voteCount: Int
        let video: Bool
        let voteAverage: Double
    }
    
    struct NowPlaying: Codable, Equatable {

        let page: Int
        let totalPages: Int
        let results: [Movie]
    }

    struct Upcoming: Codable, Equatable {

        let page: Int
        let totalPages: Int
        let results: [Movie]
    }

    struct Trending: Codable, Equatable {

        let page: Int
        let totalPages: Int
        let results: [Movie]
    }

    struct Popular: Codable, Equatable {

        let page: Int
        let totalPages: Int
        let results: [Movie]
    }
}

extension ServerModels.Movie {
    
    var votePercentage: Int {
        Int(voteAverage * 10)
    }
}

struct ImageService {
    
    enum Size: String {
        case small = "https://image.tmdb.org/t/p/w154"
        case medium = "https://image.tmdb.org/t/p/w500"
        case cast = "https://image.tmdb.org/t/p/w185"
        case original = "https://image.tmdb.org/t/p/original"
        
        func url(poster: String?) -> URL? {
            guard let poster = poster else { return nil }
            return URL(string: rawValue + poster)
        }
    }
}
