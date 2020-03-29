//
//  Movie+CoreDataProperties.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 28.03.2020.
//  Copyright © 2020 Dmitry Kocherovets. All rights reserved.
//
//

import Foundation
import CoreData


extension MovieDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieDB> {
        return NSFetchRequest<MovieDB>(entityName: "MovieDB")
    }

    @NSManaged public var overview: String
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String
    @NSManaged public var title: String
    @NSManaged public var category: Int16
    @NSManaged public var votePercentage: Int16
    @NSManaged public var id: Int64

}
