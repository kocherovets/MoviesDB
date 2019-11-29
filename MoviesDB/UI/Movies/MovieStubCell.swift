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

    @IBOutlet fileprivate weak var posterIV: UIImageView!
    @IBOutlet fileprivate weak var posterIVPanel: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterIV.layer.cornerRadius = 5
    }
}

struct MovieStubCellVM: CellModel {

    let uuid = UUID().uuidString
    
    func apply(to cell: MovieStubCell) {
    }
}
