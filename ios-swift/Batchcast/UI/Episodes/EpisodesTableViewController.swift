//
//  EpisodesTableViewController.swift
//  Batchcast
//
//  Copyright © 2016 BatchLabs. All rights reserved.
//

import UIKit

private let headerCellIdentifier = "headerCell"
private let notificationsCellIdentifier = "notificationsCell"
private let episodeCellIdentifier = "episodeCell"

class EpisodesTableViewController: UITableViewController {

    let datasource = EpisodesFakeDatasource()
    
    var source: Source? {
        didSet {
            if let source = source {
                episodes = datasource.episodesForSource(source)
            }
        }
    }
    
    var episodes: [Episode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 0 {
            return 160
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            if (indexPath as NSIndexPath).row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentifier, for: indexPath)
                cell.isUserInteractionEnabled = false
                if let cell = cell as? EpisodeHeaderCell, let source = source {
                    cell.update(source)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: notificationsCellIdentifier, for: indexPath)
                if let cell = cell as? NotificationsCell, let source = source {
                    cell.update(source)
                }
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: episodeCellIdentifier, for: indexPath)
        
        if let cell = cell as? EpisodeCell {
            cell.update(episodes[(indexPath as NSIndexPath).row])
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath as NSIndexPath).section != 1 {
            return
        }
        
        guard let source = source else {
            print("Internal error while trying to play an episode: nil source")
            return
        }
        
        Player.sharedInstance.play(source, episode: episodes[(indexPath as NSIndexPath).row])
    }
}
