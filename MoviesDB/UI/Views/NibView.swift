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
    var nibName: String? = "PosterView"

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        loadView()
    }

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        loadView()
//    }

    func loadView() {

        let nibName2 = nibName ?? String(describing: type(of: self))
        backgroundColor = .clear

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName2, bundle: bundle)
        containerView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        containerView?.frame = bounds
        containerView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView?.translatesAutoresizingMaskIntoConstraints = true

        addSubview(containerView!)

        setup()
    }

    func setup() {

    }
}
