//
//  MovieStubCell.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 02.12.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import UIKit

class MovieStubCell: XibTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

struct MovieStubCellVM: CellModel {

    let uuid = UUID().uuidString
    
    func apply(to cell: MovieStubCell) {
    }
}
