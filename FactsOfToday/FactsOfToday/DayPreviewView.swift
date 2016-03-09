//
//  DayPreviewView.swift
//  FactsOfToday
//
//  Created by Evan on 3/6/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import UIKit
import AFNetworking

protocol DayPreviewDelegate: class {
    func didSelectRow(indexPath: NSIndexPath)
}

class DayPreviewView: UIView {

	@IBOutlet weak var tableView: UITableView!
	
	var delegate: DayPreviewDelegate?
	
	var month: String?
	var day: String?
	
	var events: [Event]?
	var births: [Event]?
	var deaths: [Event]?
	
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
	
	override func awakeFromNib() {
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.reloadData()
		
		if month != nil && day != nil {
			HistoryClient.getEventsByDate(month!, day: day!) { (events, births, deaths) -> () in
				self.events = events
				self.births = births
				self.deaths = deaths
				self.tableView.reloadData()
			}
		} else {
			HistoryClient.getEventsByDate("3", day: "8") { (events, births, deaths) -> () in
				self.events = events
				self.births = births
				self.deaths = deaths
				self.tableView.reloadData()
			}
		}
	}
}

extension DayPreviewView: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 3
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "Events"
		case 1:
			return "Births"
		case 2:
			return "Deaths"
		default:
			return nil
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("cell")
		cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
		cell?.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
		cell?.textLabel?.numberOfLines = 0
//		cell!.textLabel?.text = "test with a longer message that will hopefully wrap around to be on a new line and not cover the arrow"
		
		switch indexPath.section {
		case 0:
			if events != nil {
				cell?.textLabel?.text = events![0].text
			} else {
				cell?.textLabel?.text = "Loading..."
			}
		case 1:
			if births != nil {
				cell?.textLabel?.text = births![0].text
			} else {
				cell?.textLabel?.text = "Loading..."
			}
		case 2:
			if deaths != nil {
				cell?.textLabel?.text = deaths![0].text
			} else {
				cell?.textLabel?.text = "Loading..."
			}
		default:
			cell?.textLabel?.text = "Something went wrong"
		}
		
		return cell!
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		let text = "test with a longer message that will hopefully wrap around to be on a new line and not cover the arrow"
		let attributedText = NSAttributedString(string: text, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(UIFont.systemFontSize())])
		
		let rect = attributedText.boundingRectWithSize(CGSizeMake(tableView.bounds.size.width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
		
		return rect.size.height + 40
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected")
        delegate?.didSelectRow(indexPath)
        if delegate == nil {
            print("it's nil!")
        }

		tableView.deselectRowAtIndexPath(indexPath, animated: false)
	}
}