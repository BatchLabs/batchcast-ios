//
//  EpisodeCell.swift
//  Batchcast
//
//  Copyright © 2016 BatchLabs. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {

    
    func update(_ episode: Episode) {
        self.textLabel?.text = episode.name
    }
}
