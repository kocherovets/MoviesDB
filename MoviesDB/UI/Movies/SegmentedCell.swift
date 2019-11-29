//
//  MovieCell.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 26.11.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import Foundation
import DeclarativeTVC

class SegmentedCell: UITableViewCell {

    @IBOutlet fileprivate var segmentedControl: UISegmentedControl!
    
    fileprivate var selectCommand: CommandWith<Int>? 

    @IBAction fileprivate func valueChanged(_ sender: UISegmentedControl) {
        selectCommand?.perform(with: sender.selectedSegmentIndex)
    }
}

struct SegmentedCellVM: CellModel {
    
    let uuid = "kasdklasd klas KLAdaklSD KLasdjal al"
    let selectedIndex: Int
    let selectCommand: CommandWith<Int>

    func apply(to cell: SegmentedCell) {
        
        cell.segmentedControl.selectedSegmentIndex = selectedIndex
        cell.selectCommand = selectCommand
    }
}
