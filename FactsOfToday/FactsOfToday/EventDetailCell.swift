//
//  EventDetailCell.swift
//  FactsOfToday
//
//  Created by Darrell Shi on 3/8/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class EventDetailCell: UITableViewCell {
    @IBOutlet weak var detailLabel: TTTAttributedLabel!
    
    var event: Event! {
        didSet{
            let text = NSString(string: event.text!)
            detailLabel.text = text as String

            if let links = event.links {
                for link in links {
                    if let linkStr = link.title {
                        let range = text.rangeOfString(linkStr)
                        let linkURL = link.url
                        detailLabel.addLinkToURL(linkURL!, withRange: range)
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailLabel.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension EventDetailCell: TTTAttributedLabelDelegate {
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        print(url)
        UIApplication.sharedApplication().openURL(url)
//        let webView = UIWebView(frame: self.superview!.frame)
//        webView.loadRequest(NSURLRequest(URL: url))
//        self.superview!.addSubview(webView)
    }
}