//
//  SourcesFakeDatasource.swift
//  Batchcast
//
//  Copyright © 2016 BatchLabs. All rights reserved.
//

import Foundation

// Simple fake datasource for Source structs
class SourcesFakeDatasource {
    
    fileprivate let sources: [Source] = [Source(id: 1, title: "First Example", artist: "Jon Rodberg"),
                                     Source(id: 2, title: "The Insider", artist: "Daniel Hockman"),
                                     Source(id: 3, title: "Daring Baseball", artist: "John Druder"),
                                     Source(id: 4, title: "The Yard", artist: "Unknown"),
                                     Source(id: 5, title: "Second Example", artist: "Jon Rodberg"),
                                     Source(id: 6, title: "Batch Technica", artist: "Independent"),
                                     Source(id: 7, title: "Aandpush", artist: "Press Inc."),
                                     Source(id: 8, title: "Batch News", artist: "Batch.com")]
    
    func allSources() -> [Source] {
        return sources
    }
}
