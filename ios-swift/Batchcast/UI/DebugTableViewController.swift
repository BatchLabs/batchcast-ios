//
//  DebugTableViewController.swift
//  Batchcast
//
//  Copyright © 2016 BatchLabs. All rights reserved.
//

import UIKit
import Batch.User
import AdSupport

class DebugTableViewController: UITableViewController {

    @IBOutlet weak var apiKey: UILabel!
    @IBOutlet weak var installID: UILabel!
    @IBOutlet weak var idfa: UILabel!
    @IBOutlet weak var lastToken: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshInfo()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath as NSIndexPath).section == 1 {
            BatchUser.printDebugInformation()
        }
    }
    
    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if (indexPath as NSIndexPath).section == 0, let cell = tableView.cellForRow(at: indexPath), let text = cell.detailTextLabel?.text {
            UIPasteboard.general.string = text
        }
    }
    
    func refreshInfo() {
        apiKey.text = BatchAPIKey
        installID.text = BatchUser.installationID() ?? "<Unknown>"
        idfa.text = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        lastToken.text = BatchPush.lastKnownPushToken() ?? "<Unknown>"
    }
    
    @IBAction func shareAction(_ sender: AnyObject) {
        // Allow the user to share the user identifiers or copy them
        
        let infos = NSMutableString()
        
        infos.append("Batchcast Debug information --\n\n")
        infos.append("API Key: \(BatchAPIKey)\n")
        infos.append("InstallID: \(BatchUser.installationID() ?? "<Unknown>")\n")
        infos.append("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier.uuidString)\n")
        infos.append("Last known push token: \(BatchPush.lastKnownPushToken() ?? "<Unknown>")\n")
        
        let activityViewcontroller = UIActivityViewController(activityItems: [infos], applicationActivities: nil)
        
        present(activityViewcontroller, animated: true, completion: nil)
    }
}
