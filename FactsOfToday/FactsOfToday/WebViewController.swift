//
//  WebViewController.swift
//  FactsOfToday
//
//  Created by Darrell Shi on 3/22/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import UIKit
import MapKit

class WebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
	@IBOutlet weak var mapButton: UIBarButtonItem!
	var url: NSURL?
	var coordinates: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = url {
			webView.delegate = self
            webView.loadRequest(NSURLRequest(URL: url))
        }
    }
	
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "toMapView" {
			let navigationController = segue.destinationViewController as! UINavigationController
			let mapViewController = navigationController.topViewController as! MapViewController
			
			mapViewController.coordinates = coordinates
//			mapViewController.articleTitle = link?.title
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		let url = request.URL
		
		if let articleTitle = WikipediaClient.getArticleTitleUrl(url) {
			WikipediaClient.getCoordinatesForArticleWithTitle(articleTitle, completion: { (coordinates) in
				if let coordinates = coordinates {
					self.mapButton.enabled = true
					self.coordinates = coordinates
				} else {
					self.mapButton.enabled = false
				}
			})
		} else {
			self.mapButton.enabled = false
		}
		
		return true
	}
}
