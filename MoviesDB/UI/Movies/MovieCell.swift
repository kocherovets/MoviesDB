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

class MovieCell: UITableViewCell {

    @IBOutlet fileprivate weak var posterV: PosterView!
    @IBOutlet fileprivate weak var titleL: UILabel!
    @IBOutlet fileprivate weak var overviewLabel: UILabel!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    @IBOutlet fileprivate weak var votePercentageLabel: UILabel!
}

struct MovieCellVM: CellModel {

    let title: String?
    let overview: String?
    let date: String?
    let votePercentage: Int
    let posterPath: String?

    func apply(to cell: MovieCell) {

        cell.titleL.text = title
        cell.overviewLabel.text = overview
        cell.dateLabel.text = date
        cell.votePercentageLabel.text = "\(votePercentage)%"
        cell.posterV.posterIV?.kf.setImage(with: ImageService.Size.small.url(poster: posterPath))
    }
}
