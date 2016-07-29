//
//  EventManager.swift
//  Batchcast
//
//  Copyright © 2016 BatchLabs. All rights reserved.
//

import Foundation
import Batch.User

private struct EventKeys {
    fileprivate static let EpisodePlayed = "source_episode_played"
}

class EventManager {
    // This class only has class methods
    fileprivate init() {}
    
    // Track when the user starts playing an episode
    class func trackEpisodePlay(_ episode: Episode, source: Source) {
        print("Debug: tracking episode play")
        
        // Tracking the source name as the event label makes more sense for targeting
        BatchUser.trackEvent(EventKeys.EpisodePlayed, withLabel: source.backendName, data: ["episode_name": episode.name])
    }
}
