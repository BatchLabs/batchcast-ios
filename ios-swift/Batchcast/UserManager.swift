//
//  UserManager.swift
//  Batchcast
//
//  Copyright © 2016 BatchLabs. All rights reserved.
//

import Foundation
import Batch.User

private let onboardingAttemptedKey = "onboardingAttempted"
private let usernameKey = "accountUsername"
private let premiumKey = "premiumFeatures"

class UserManager {
    var isLoggedIn: Bool {
        get {
            return username != nil
        }
    }
    
    var onboardingAttempted: Bool {
        get {
            return UserDefaults.standard.bool(forKey: onboardingAttemptedKey)
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: onboardingAttemptedKey)
        }
    }
    
    var username: String? {
        get {
            return UserDefaults.standard.string(forKey: usernameKey)
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: usernameKey)
        }
    }
    
    func login(_ username: String, premium: Bool) {
        self.username = username
        UserDefaults.standard.set(premium, forKey: premiumKey)
        syncBatchUserInfo()
    }
    
    func logout() {
        username = nil
        UserDefaults.standard.removeObject(forKey: premiumKey)
    }
    
    func syncBatchUserInfo() {
        let username = self.username
        let editor = BatchUser.editor()
        editor.setIdentifier(username)
        
        if username != nil {
            editor.setAttribute(UserDefaults.standard.bool(forKey: premiumKey) as NSObject?, forKey: "premium")
        }
        
        editor.save()
        
        SubscriptionManager().syncDataWithBatch()
    }
}
