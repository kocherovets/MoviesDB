//
//  PosterView.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 01.12.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import UIKit

@IBDesignable
class PosterView: NibView {

    @IBInspectable var shadowed: Bool = false {
        didSet {
            if shadowed {
                layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
                layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                layer.shadowOpacity = 1.0
                layer.shadowRadius = 8.0
                layer.masksToBounds = false
            } else {
                layer.shadowColor = nil
                layer.masksToBounds = true
            }
        }
    }

    @IBOutlet weak var posterIV: UIImageView!

    override func setup() {

        posterIV.layer.cornerRadius = 5
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        posterIV.image = UIImage(named: "posterSample")
    }
}

