//
//  Source.swift
//  Batchcast
//
//  Copyright © 2016 BatchLabs. All rights reserved.
//

import Foundation
import UIKit

// Source represents a podcast source
struct Source {
    let id: Int
    let title: String
    let artist: String
    let backendName: String
    let logo: SourceLogo = SourceLogo.random()
    
    init(id: Int, title: String, artist: String) {
        self.id = id
        self.title = title
        self.artist = artist
        self.backendName = title.lowercased().replacingOccurrences(of: " ", with: "_")
    }
}

// Logos are simulated using a gradient. This describes it.
struct SourceLogo {
    let startColor: UIColor
    let endColor: UIColor
    
    static func random() -> SourceLogo {
        let baseColor = randomColorPalette[Int(arc4random_uniform(UInt32(randomColorPalette.count)))]
        
        // Get the color's HSB representation to easily darken it
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        baseColor.getHue(&hsba.h, saturation: &hsba.s, brightness: &hsba.b, alpha: &hsba.a)
        hsba.b = hsba.b * 0.9 // Reduce brightness to, well, darken the color
        
        let darkenedColor = UIColor(hue: hsba.h, saturation: hsba.s, brightness: hsba.b, alpha: hsba.a)
        
        return SourceLogo(startColor: baseColor, endColor: darkenedColor)
    }
}

let randomColorPalette: [UIColor] = [
    UIColor(red:1.00, green:0.20, blue:0.17, alpha:1.00),
    UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.00),
    UIColor(red:1.00, green:0.77, blue:0.01, alpha:1.00),
    UIColor(red:0.26, green:0.83, blue:0.35, alpha:1.00),
    UIColor(red:0.18, green:0.63, blue:0.84, alpha:1.00),
    UIColor(red:0.00, green:0.44, blue:1.00, alpha:1.00),
    UIColor(red:0.30, green:0.30, blue:0.82, alpha:1.00),
    UIColor(red:1.00, green:0.15, blue:0.29, alpha:1.00)
]
