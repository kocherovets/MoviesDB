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

    @IBOutlet fileprivate weak var posterIV: UIImageView!
    @IBOutlet fileprivate weak var posterIVPanel: UIView!
    @IBOutlet fileprivate weak var titleL: UILabel!
    @IBOutlet fileprivate weak var overviewLabel: UILabel!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    @IBOutlet fileprivate weak var votePercentageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterIV.layer.cornerRadius = 5

        posterIVPanel.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        posterIVPanel.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        posterIVPanel.layer.shadowOpacity = 1.0
        posterIVPanel.layer.shadowRadius = 8.0
        posterIVPanel.layer.masksToBounds = false
    }
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
        cell.posterIV.kf.setImage(with: ImageService.Size.small.url(poster: posterPath))
    }
}
