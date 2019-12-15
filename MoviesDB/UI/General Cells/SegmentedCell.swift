//
//  SegmentedCell.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 02.12.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import UIKit

class SegmentedCell: XibTableViewCell {

    @IBOutlet fileprivate var segmentedControl: UISegmentedControl!
    
    fileprivate var selectCommand: CommandWith<Int>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
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
