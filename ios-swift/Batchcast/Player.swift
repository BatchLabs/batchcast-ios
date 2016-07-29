//
//  Player.swift
//  Batchcast
//
//  Copyright © 2016 BatchLabs. All rights reserved.
//

import Foundation
import Batch.User

class Player {
    static let sharedInstance = Player()
    
    // Instanciating this class has no sense, it's singleton only
    fileprivate init() {}
    
    func play(_ source: Source, episode: Episode) {
        // Tell analytics that the user started playing an episode
        EventManager.trackEpisodePlay(episode, source: source)
        
        // Do not actually play the file, this is not a real podcast player ;)
    }
}
