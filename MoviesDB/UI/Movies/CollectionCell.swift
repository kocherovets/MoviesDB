//
//  CollectionCell.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 01.12.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import UIKit
import DeclarativeTVC

class CollectionCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
}

struct CollectionCellVM: CellModel {
    
    let items: [ColorCellVM]
    
    private let collectionDS = CollectionDS()

    func apply(to cell: CollectionCell) {

        collectionDS.set(collectionView: cell.collectionView, items: items, animated: false)
    }
}

extension CollectionCellVM: Equatable {
    
    static func == (lhs: CollectionCellVM, rhs: CollectionCellVM) -> Bool {
        return lhs.items == rhs.items
    }
}

class ColorCell: UICollectionViewCell {

    @IBOutlet fileprivate weak var posterV: PosterView!
}

struct ColorCellVM: CellModel {

    let posterPath: String?

    func apply(to cell: ColorCell) {

        cell.posterV.posterIV?.kf.setImage(with: ImageService.Size.small.url(poster: posterPath))
    }
}
