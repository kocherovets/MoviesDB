//
//  CollectionCell.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 02.12.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import UIKit
import DeclarativeTVC

class CollectionCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
}

struct CollectionCellVM: CellModel {
    
    let items: [PosterCVCellVM]
    
    private let collectionDS = CollectionDS(cellType: .xib)

    func apply(to cell: CollectionCell) {

        collectionDS.set(collectionView: cell.collectionView, items: items, animated: false)
    }
}

extension CollectionCellVM: Equatable {
    
    static func == (lhs: CollectionCellVM, rhs: CollectionCellVM) -> Bool {
        return lhs.items == rhs.items
    }
}
