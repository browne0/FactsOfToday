//
//  WebViewController.swift
//  FactsOfToday
//
//  Created by Darrell Shi on 3/22/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var url: NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = url {
            webView.loadRequest(NSURLRequest(URL: url))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
