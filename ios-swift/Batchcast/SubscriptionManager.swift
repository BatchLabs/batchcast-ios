//
//  SubscriptionManager.swift
//  Batchcast
//
//  Copyright © 2016 BatchLabs. All rights reserved.
//

import Foundation
import Batch.User

private let defaultsSetKey = "defaults_set"

private let newEpisodesKey = "wants_new_episodes"

private let suggestedContentKey = "wants_suggested_content"
private let suggestionCategoriesKeys = "suggestion_topics"
private let sourceSubscriptionListKey = "subscribed_sources"

let suggestionCategorySports = "sports"
let suggestionCategoryHighTech = "high_tech"
let suggestionCategoryGames = "games"

class SubscriptionManager {

    var automaticBatchSync: Bool = true

    var shouldSetDefaults: Bool {
        get {
            return !UserDefaults.standard.bool(forKey: defaultsSetKey)
        }
    }

    var newEpisodes: Bool {
        get {
            return UserDefaults.standard.bool(forKey: newEpisodesKey)
        }

        set {
            UserDefaults.standard.setValue(newValue, forKey: newEpisodesKey)
            if automaticBatchSync {
                syncDataWithBatch()
            }
        }
    }

    var suggestedContent: Bool {
        get {
            return UserDefaults.standard.bool(forKey: suggestedContentKey)
        }

        set {
            UserDefaults.standard.setValue(newValue, forKey: suggestedContentKey)
            if automaticBatchSync {
                syncDataWithBatch()
            }
        }
    }
    
    func isSubscribedToSource(_ name: String) -> Bool {
        // This method can be improved by caching the subscription list to avoid the overhead of reading the user defaults
        
        if let subscribedSources = UserDefaults.standard.stringArray(forKey: sourceSubscriptionListKey) {
            return subscribedSources.firstIndex(of: name) != nil
        }
        
        return false
    }
    
    func isSubscribedToSuggestion(_ name: String) -> Bool {
        
        if let subscribedSuggestions = UserDefaults.standard.stringArray(forKey: suggestionCategoriesKeys) {
            return subscribedSuggestions.firstIndex(of: name) != nil
        }
        
        return false
    }
    
    func toggleSuggestionCategory(_ name: String, enabled: Bool) {
        toggleArrayValue(suggestionCategoriesKeys, value: name, enabled: enabled)
    }
    
    func toggleSourceSubscription(_ source: String, enabled: Bool) {
        toggleArrayValue(sourceSubscriptionListKey, value: source, enabled: enabled)
    }
    
    fileprivate func toggleArrayValue(_ arrayName: String, value: String, enabled: Bool) {
        let defaults = UserDefaults.standard
        var array: [String] = defaults.stringArray(forKey: arrayName) ?? []
        
        if enabled {
            if array.firstIndex(of: value) == nil {
                array.append(value)
            }
        } else {
            array = array.filter({ (arrayItem) -> Bool in
                arrayItem != value
            })
        }
        
        defaults.setValue(array, forKey: arrayName)
        
        if automaticBatchSync {
            syncDataWithBatch()
        }
    }

    // Sets the default subscriptions
    func initDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: defaultsSetKey)

        defaults.set(true, forKey: newEpisodesKey)
        defaults.set(true, forKey: suggestedContentKey)
        defaults.setValue([suggestionCategorySports, suggestionCategoryHighTech, suggestionCategoryGames], forKey: suggestionCategoriesKeys)

        defaults.setValue(SourcesFakeDatasource().allSources().map({ (source) -> String in
            source.backendName
        }), forKey: sourceSubscriptionListKey)
    }

    // Synchronise data in NSUserDefaults with Batch
    func syncDataWithBatch() {
        let defaults = UserDefaults.standard

        let editor = BatchUser.editor()

        editor.setAttribute(NSNumber(value: defaults.bool(forKey: newEpisodesKey)), forKey:newEpisodesKey)
        editor.setAttribute(NSNumber(value: defaults.bool(forKey: suggestedContentKey)), forKey:suggestedContentKey)

        editor.clearTagCollection(suggestionCategoriesKeys)
        defaults.stringArray(forKey: suggestionCategoriesKeys)?.forEach({ (category) in
            editor.addTag(category, inCollection: suggestionCategoriesKeys)
        })

        editor.clearTagCollection(sourceSubscriptionListKey)

        if UserManager().isLoggedIn {
            defaults.stringArray(forKey: sourceSubscriptionListKey)?.forEach({ (category) in
                editor.addTag(category, inCollection: sourceSubscriptionListKey)
            })
        }

        editor.save()
    }
}
