//
//  NibView.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 01.12.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import UIKit

class NibView: UIView {

    @IBOutlet weak var containerView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        loadView()
    }

    private func loadView() {
        backgroundColor = .clear

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        containerView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.translatesAutoresizingMaskIntoConstraints = true

        addSubview(containerView)
        
        setup()
        
        containerView.prepareForInterfaceBuilder()
    }

    func setup() {

    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
//        xibSetup()
        print(111111)
        containerView.prepareForInterfaceBuilder()
    }
}
