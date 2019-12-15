//
//  MovieDetails.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 15.12.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import Foundation

extension ServerModels {

    struct MovieDetails: Codable, Equatable {

        let adult: Bool
        let backdropPath: String?
//        let belongsToCollection:
        let budget: Int
        
        struct Genre: Codable, Equatable {
            let id: Int
            let name: String
        }
        let genres: [Genre]
        
        let homepage: String?
        let id: Int
        let imdbId: String?
        let originalLanguage: String
        let originalTitle: String
        let overview: String?
        let popularity: Double
        let posterPath: String?
        
        struct ProductionCompany: Codable, Equatable {
            let id: Int
            let name: String
            let logoPath: String?
            let originCountry: String
        }
        let productionCompanies: [ProductionCompany]
        
        struct ProductionCountry: Codable, Equatable {
            let name: String
            let iso31661: String
        }
        let productionCountries: [ProductionCountry]
        
        let releaseDate: String
        let revenue: Int
        let runtime: Int?
        
        struct SpokenLanguage: Codable, Equatable {
            let name: String
            let iso6391: String
        }
        let spokenLanguages: [SpokenLanguage]
        
        let status: String
        let tagline: String?
        let title: String
        let video: Bool
        let voteCount: Int
        let voteAverage: Double
    }
}
