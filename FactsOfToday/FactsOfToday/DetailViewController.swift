//
//  DetailViewController.swift
//  FactsOfToday
//
//  Created by Darrell Shi on 3/8/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import UIKit
import Social

protocol WebViewDelegate {
    func openURL(url: NSURL)
}

class DetailViewController: UIViewController, UIViewControllerPreviewingDelegate {
    var events: [Event]?
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        if traitCollection.forceTouchCapability == .Available {
            /*
             Register for `UIViewControllerPreviewingDelegate` to enable
             "Peek" and "Pop".
             (see: MasterViewController+UIViewControllerPreviewing.swift)
             
             The view controller will be automatically unregistered when it is
             deallocated.
             */
            registerForPreviewingWithDelegate(self, sourceView: view)
        }
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
		
		cell.setValues(events?[indexPath.row], delegate: self)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let twitterShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterShare.setInitialText("#factsOfToday " + events![indexPath.row].text!)
            self.presentViewController(twitterShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account in the Settings to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: twitterHandler))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func twitterHandler(alert: UIAlertAction) {
        UIApplication.sharedApplication().openURL(NSURL(string:"prefs:root=TWITTER")!)
    }
    
    func openURL(url: NSURL) {
        self.performSegueWithIdentifier("ToWebView", sender: url)
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController")
        return vc
    }

    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        performSegueWithIdentifier("ToWebView", sender: nil)
    }
}