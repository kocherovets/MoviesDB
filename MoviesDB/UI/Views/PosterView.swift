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

    @IBInspectable var shadowed: Bool = true {
        didSet {
            updateUI()
        }
    }

    @IBInspectable var conerRadius: CGFloat = 5 {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var posterIV: UIImageView!

    override func setup() {

        updateUI()
    }

    private func updateUI() {
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

        if posterIV != nil {
            posterIV.layer.cornerRadius = conerRadius
            layer.cornerRadius = conerRadius
        }
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        posterIV.image = UIImage(named: "posterSample", in: Bundle(for: type(of: self)), compatibleWith: nil)
    }
}

@IBDesignable
class PosterStubView: UIView {

    @IBInspectable var shadowed: Bool = false {
        didSet {
            updateUI()
        }
    }

    @IBInspectable var conerRadius: CGFloat = 5 {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }

    private func updateUI() {
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

        layer.cornerRadius = conerRadius
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateUI()
    }
}
