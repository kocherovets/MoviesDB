//
//  PosterView.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 01.12.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import UIKit



//@IBDesignable
//class PosterView: UIImageView {
//
//    @IBInspectable var shadowed: Bool = true {
//        didSet {
//            if shadowed {
//                layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
//                layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//                layer.shadowOpacity = 1.0
//                layer.shadowRadius = 8.0
//                layer.masksToBounds = false
//            } else {
//                layer.shadowColor = nil
//                layer.masksToBounds = true
//            }
//        }
//    }
//
//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//
//        let dynamicBundle = Bundle(for: type(of: self))
//        image = UIImage(named: "posterSample", in: dynamicBundle, compatibleWith: nil)
////        image = UIImage(named: "posterSample")
//    }
//}

@IBDesignable
class PosterView: UIView {

    @IBInspectable var shadowed: Bool = true {
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

    var containerView: UIView?
    var nibName: String? = "PosterView"

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        loadView()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//
//        loadView()
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        loadView()
    }

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

        posterIV.layer.cornerRadius = 5
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        loadView()
        let dynamicBundle = Bundle(for: type(of: self))
        posterIV.image = UIImage(named: "posterSample", in: dynamicBundle, compatibleWith: nil)
    }

//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//        posterIV.image = UIImage(named: "posterSample")
//    }
}

