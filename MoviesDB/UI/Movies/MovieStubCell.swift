//
//  MovieCell.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 26.11.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import Foundation
import DeclarativeTVC
import Kingfisher

class MovieStubCell: UITableViewCell {

}

struct MovieStubCellVM: CellModel {

    let uuid = UUID().uuidString
    
    func apply(to cell: MovieStubCell) {
    }
}
