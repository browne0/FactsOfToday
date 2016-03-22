//
//  DetailViewController.swift
//  FactsOfToday
//
//  Created by Darrell Shi on 3/8/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import UIKit

protocol WebViewDelegate {
    func openURL(url: NSURL)
}

class DetailViewController: UIViewController {
    var events: [Event]?
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
//        HistoryClient.getEventsByDate("6", day: "1") { (events, births, deaths) -> () in
//            if let events = events {
//                self.events = events
//                self.tableView.reloadData()
//            } else if let events = births {
//                self.events = events
//                self.tableView.reloadData()
//            } else if let events = deaths {
//                self.events = events
//                self.tableView.reloadData()
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToWebView" {
            let url = sender as! NSURL
            let vc = segue.destinationViewController as! WebViewController
            vc.url = url
        }
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource, WebViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = events {
            return events.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventDetailCell") as! EventDetailCell
        
        cell.event = events?[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func openURL(url: NSURL) {
        self.performSegueWithIdentifier("ToWebView", sender: url)
    }
}