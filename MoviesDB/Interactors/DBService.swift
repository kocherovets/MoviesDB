//
//  DBService.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 28.03.2020.
//  Copyright © 2020 Dmitry Kocherovets. All rights reserved.
//

import Foundation
import CoreData

class DBService {

    private var persistentContainer: NSPersistentContainer = {

        guard let modelURL = Bundle(for: DBService.self).url(forResource: "MoviesDB", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }

        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }

        let container = NSPersistentContainer(name: "MoviesDB", managedObjectModel: mom)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            print("storeDescription = \(storeDescription)")
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    } ()

    private let moc: NSManagedObjectContext

    init() {
        self.moc = persistentContainer.newBackgroundContext()
    }

    func clear() {

    }

    func saveMovies(movies: [ServerModels.Movie], category: MoviesState.Category) -> Error? {

        do {
            for serverMovie in movies {
                let movie = MovieDB(context: moc)
                movie.id = Int64(serverMovie.id)
                movie.title = serverMovie.title
                movie.overview = serverMovie.overview
                movie.releaseDate = serverMovie.releaseDate
                movie.votePercentage = Int16(serverMovie.votePercentage)
                movie.posterPath = serverMovie.posterPath
                movie.category = Int16(category.rawValue)
                moc.insert(movie)
            }

            try moc.save()
        }
        catch {
            return error
        }
        return nil
    }

    func movies(category: MoviesState.Category) -> [MoviesState.Movie] {

        do {
            let request = NSFetchRequest<MovieDB>(entityName: "MovieDB")
            request.predicate = NSPredicate(format: "category == \(category.rawValue)")

            let movies = try moc.fetch(request)

            return movies.map { MoviesState.Movie(movieDB: $0) }
        }
        catch {
            return []
        }
    }

}

