//
//  SourcesCell.swift
//  Batchcast
//
//  Copyright © 2016 BatchLabs. All rights reserved.
//

import UIKit

class SourcesCell: UICollectionViewCell {

    @IBOutlet weak var image: GradientImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var artist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        image.backgroundColors = [UIColor.white, UIColor.gray]
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = false
        
        
        let imglayer = image.layer
        imglayer.masksToBounds = false
        imglayer.shadowColor = UIColor.black.cgColor
        imglayer.shadowOffset = CGSize.zero
        imglayer.shadowOpacity = 0.3
        imglayer.shadowRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Recompute the path with th new view size
        let shadowPath = UIBezierPath(rect: image.bounds)
        image.layer.shadowPath = shadowPath.cgPath
    }
    
    func updateWithSource(_ source: Source) {
        name?.text = source.title
        artist?.text = source.artist
        image.backgroundColors = [source.logo.startColor, source.logo.endColor]
    }
}
