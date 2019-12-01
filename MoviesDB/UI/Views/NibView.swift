//
//  NibView.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 01.12.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import UIKit

class NibView: UIView {

    var containerView: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        loadView()
    }

    func loadView() {

        backgroundColor = .clear

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        containerView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        containerView?.frame = bounds
        containerView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView?.translatesAutoresizingMaskIntoConstraints = true

        addSubview(containerView!)

        setup()
    }

    func setup() {

    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        loadView()
        containerView?.prepareForInterfaceBuilder()
    }

}
