//
//  GradientImageView.swift
//  Batchcast
//
//  Copyright © 2016 BatchLabs. All rights reserved.
//

import UIKit

// ImageView that supports a gradient background
class GradientImageView: UIImageView {

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    var backgroundColors: [UIColor]? {
        didSet {
            let layer = self.layer as! CAGradientLayer
            
            if let colors = backgroundColors {
                layer.colors = colors.map({ (color: UIColor) -> CGColor in
                    color.cgColor
                })
            } else {
                layer.colors = nil
            }
        }
    }
}
