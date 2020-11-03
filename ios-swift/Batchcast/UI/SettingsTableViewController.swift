//
//  SettingsTableViewController.swift
//  Batchcast
//
//  Created by Arnaud Barisain-Monrose on 29/07/2016.
//  Copyright © 2016 BatchLabs. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var enablePush: UISwitch!
    @IBOutlet weak var newEpisodes: UISwitch!
    @IBOutlet weak var suggestedContent: UISwitch!
    
    @IBOutlet weak var suggestionSport: UISwitch!
    @IBOutlet weak var suggestionHighTech: UISwitch!
    @IBOutlet weak var suggestionGames: UISwitch!
    
    @IBOutlet var notificationSwitches: [UISwitch]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshForm()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Refresh the notification settings when we come back in the app, since the user can have changed them in iOS' settings
        NotificationCenter.default.addObserver(self, selector: #selector(refreshForm), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        // Also refresh the notification settings when iOS tells us they changed, since DidBecomeActiveNotification arrives a little too early
        NotificationCenter.default.addObserver(self, selector: #selector(refreshForm), name: NSNotification.Name(rawValue: UserNotificationChanged), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (section == 0) {
            if let username = UserManager().username {
                return "Logged in as \(username)"
            }
        }
        
        return super.tableView(tableView, titleForHeaderInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 0 {
            // Login button
            let userManager = UserManager()
            if userManager.isLoggedIn {
                userManager.logout()
                refreshForm()
            } else {
                performSegue(withIdentifier: "loginSegue", sender: self)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func refreshForm() {
        let loggedIn = UserManager().isLoggedIn
        let subscriptionManager = SubscriptionManager()
        
        // Enable all switches by default
        notificationSwitches.forEach({ (notifSwitch) in
            notifSwitch.isEnabled = true
        })
        
        // Logged out users can't get notifications about new episodes
        if !loggedIn {
            newEpisodes.isOn = false
            newEpisodes.isEnabled = false
        } else {
            newEpisodes.isOn = subscriptionManager.newEpisodes
            newEpisodes.isEnabled = true
        }
        
        let suggestedContentEnabled = subscriptionManager.suggestedContent
        
        suggestedContent.isOn = suggestedContentEnabled
        suggestionSport.isOn = subscriptionManager.isSubscribedToSuggestion(suggestionCategorySports)
        suggestionHighTech.isOn = subscriptionManager.isSubscribedToSuggestion(suggestionCategoryHighTech)
        suggestionGames.isOn = subscriptionManager.isSubscribedToSuggestion(suggestionCategoryGames)
        
        if !suggestedContentEnabled {
            suggestionSport.isEnabled = false
            suggestionHighTech.isEnabled = false
            suggestionGames.isEnabled = false
        }
        
        // Set the "enable push notifications" switch value according to the system settings
        // It is a special toggle
        if let notifSettings = UIApplication.shared.currentUserNotificationSettings {
            enablePush.isOn = notifSettings.types.rawValue != 0
        } else {
            enablePush.isOn = false
        }
        
        // If push is not enabled, force disable every other switch
        if !enablePush.isOn {
            notificationSwitches.forEach({ (notifSwitch) in
                notifSwitch.isEnabled = false
            })
        }
        
        let oldLoginLabel = loginButton.currentTitle
        
        if loggedIn {
            loginButton.setTitle("Log out", for: UIControl.State())
        } else {
            loginButton.setTitle("Log in", for: UIControl.State())
        }
        
        // If the button label changed, we want to update the "Logged in as xxx" section header
        if oldLoginLabel != loginButton.currentTitle {
            tableView.reloadData()
        }

    }
    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func enablePushToggled(_ sender: AnyObject) {
        // If we're sure we never asked for the OS settings, show the notification optin modal
        if !PushManager().didTriggerSystemPopup {
            self.enablePush.setOn(!self.enablePush.isOn, animated: true)
            
            performSegue(withIdentifier: "enablePushSegue", sender: self)
            
            return
        }
        
        // Tell the user that we will redirect him to iOS settings
        // This assumes that he already has been asked to get notifications
        
        let alert = UIAlertController(title: "Toggle push notifications",
                                      message: "In order to change the global notification settings, you'll be redirected to iOS' settings.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Go", style: .default) { (_) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.enablePush.setOn(!self.enablePush.isOn, animated: true)
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func newEpisodesToggled(_ sender: AnyObject) {
        SubscriptionManager().newEpisodes = newEpisodes.isOn
        refreshForm()
    }
    
    @IBAction func suggestedContentToggled(_ sender: AnyObject) {
        SubscriptionManager().suggestedContent = suggestedContent.isOn
        refreshForm()
    }
    
    @IBAction func suggestionCategoryToggled(_ sender: AnyObject) {
        if let sender = sender as? UISwitch {
            var topicName: String?
            
            switch sender {
            case suggestionSport:
                topicName = suggestionCategorySports
                break
            case suggestionGames:
                topicName = suggestionCategoryGames
                break
            case suggestionHighTech:
                topicName = suggestionCategoryHighTech
                break
            default:
                // Do nothing
                break
            }
            
            if let topicName = topicName {
                SubscriptionManager().toggleSuggestionCategory(topicName, enabled: sender.isOn)
            }
        }
    }
}
