//
//  EpisodesFakeDatasource.swift
//  Batchcast
//
//  Copyright © 2016 BatchLabs. All rights reserved.
//

import Foundation

class EpisodesFakeDatasource {
    
    fileprivate var episodes: [Episode]
    
    init() {
        episodes = []
        for i in 1...10 {
            episodes.append(Episode(name: "Episode \(i)"))
        }
    }
    
    func episodesForSource(_ source: Source) -> [Episode] {
        return episodes
    }
}
