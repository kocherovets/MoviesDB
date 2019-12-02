//
//  MovieCell.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 02.12.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import UIKit
import DeclarativeTVC
import Kingfisher

class MovieCell: UITableViewCell {

    @IBOutlet fileprivate weak var posterV: PosterView!
    @IBOutlet fileprivate weak var titleL: UILabel!
    @IBOutlet fileprivate weak var overviewLabel: UILabel!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    @IBOutlet fileprivate weak var votePercentageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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

        cell.posterV.shadowed = false
        cell.posterV.conerRadius = 5
        cell.posterV.posterIV?.kf.setImage(with: ImageService.Size.small.url(poster: posterPath),
                                           placeholder: UIImage(named: "posterStub")) { result in
            switch result {
            case .success:
                cell.posterV.shadowed = true
            case .failure:
                break
            }
        }
    }
}
