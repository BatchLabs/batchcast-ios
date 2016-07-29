//
//  NotificationsCell.swift
//  Batchcast
//
//  Created by Arnaud Barisain-Monrose on 02/08/2016.
//  Copyright © 2016 BatchLabs. All rights reserved.
//

import UIKit

class NotificationsCell: UITableViewCell {

    @IBOutlet weak var notifsEnabledSwitch: UISwitch!
    
    var source: Source?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Disable the switch until a source is added to avoid a deceptive UI
        notifsEnabledSwitch.isEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }
    
    func update(_ source: Source) {
        self.source = source
        notifsEnabledSwitch.isEnabled = true
        notifsEnabledSwitch.isOn = SubscriptionManager().isSubscribedToSource(source.backendName)
    }
    
    
    @IBAction func notificationToggledAction(_ sender: AnyObject) {
        if let source = source {
            SubscriptionManager().toggleSourceSubscription(source.backendName, enabled: notifsEnabledSwitch.isOn)
        }
    }
}
