//
//  PosterCVCell.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 02.12.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import UIKit
import DeclarativeTVC
import Kingfisher

class PosterCVCell: UICollectionViewCell {

    @IBOutlet fileprivate weak var posterV: PosterView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

struct PosterCVCellVM: CellModel {

    let posterPath: String?

    func apply(to cell: PosterCVCell) {

        cell.posterV.posterIV?.kf.setImage(with: ImageService.Size.small.url(poster: posterPath),
                                           placeholder: UIImage(named: "posterStub"))
    }
}
