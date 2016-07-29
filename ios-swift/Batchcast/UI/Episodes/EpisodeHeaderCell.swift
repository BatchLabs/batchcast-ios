//
//  EpisodeHeaderCell.swift
//  Batchcast
//
//  Copyright © 2016 BatchLabs. All rights reserved.
//

import UIKit

class EpisodeHeaderCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var artist: UILabel!
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        return
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        return
    }
    
    func update(_ source: Source) {
        backgroundColors = [source.logo.startColor, source.logo.endColor]
        name?.text = source.title
        artist?.text = source.artist
    }
    
}
