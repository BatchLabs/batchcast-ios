//
//  PushManager.swift
//  Batchcast
//
//  Copyright © 2016 BatchLabs. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import Batch.Push

private let systemPopupTriggeredKey = "systemPopupTriggered"

let markAsReadActionIdentifier = "mark_read"
let downloadActionIdentifier = "download"
let newEpisodeCategoryIdentifier = "new_episode"

let markAsReadActionLabel = "Mark as read"
let downloadActionLabel = "Download"

// Manages push notification registration status and options
class PushManager {
    
    // Track the system notification popup
    // Note that this isn't entirely accurate since we can't know if we already did it,
    // but we can only know if we asked it once for this install
    // Since iOS 10, there is a way to know this for sure. This code doesn't use it
    // for now, since it is asynchronous and changes the application flow significantly
    var didTriggerSystemPopup: Bool {
        get {
            return UserDefaults.standard.bool(forKey: systemPopupTriggeredKey)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: systemPopupTriggeredKey)
        }
    }

    func register() {
        
        if #available(iOS 10, *) {
            // Batch automatically converts compat actions to th enew format, but that's not recommended
            // so we'll create native ones
            BatchPush.setNotificationsCategories(createActions())
        } else {
            BatchPush.setNotificationsCategories(createCompatActions())
        }
        
        BatchPush.registerForRemoteNotifications()
        didTriggerSystemPopup = true
    }
    
    func createCompatActions() -> Set<UIUserNotificationCategory> {
        
        let markAsReadAction = UIMutableUserNotificationAction()
        markAsReadAction.identifier = markAsReadActionIdentifier
        markAsReadAction.title = markAsReadActionLabel
        markAsReadAction.activationMode = .background
        markAsReadAction.isAuthenticationRequired = false
        markAsReadAction.isDestructive = false // Could be argued that marking a podcast as read is destructive ;)
        
        let downloadAction = UIMutableUserNotificationAction()
        downloadAction.identifier = downloadActionIdentifier
        downloadAction.title = downloadActionLabel
        downloadAction.activationMode = .foreground
        downloadAction.isAuthenticationRequired = false
        downloadAction.isDestructive = false
        
        let category = UIMutableUserNotificationCategory()
        category.identifier = newEpisodeCategoryIdentifier
        category.setActions([markAsReadAction, downloadAction], for: .minimal)
        
        return [category]
    }
    
    @available(iOS 10.0, *)
    func createActions() -> Set<UNNotificationCategory> {
        
        let markAsReadAction = UNNotificationAction(identifier: markAsReadActionIdentifier, title: markAsReadActionLabel, options: [])
        
        let downloadAction = UNNotificationAction(identifier: downloadActionIdentifier, title: downloadActionLabel, options: [.foreground])
        
        let category = UNNotificationCategory(identifier: newEpisodeCategoryIdentifier, actions: [markAsReadAction, downloadAction], intentIdentifiers: [], options: [.allowInCarPlay])
    
        return [category]
    }
}
