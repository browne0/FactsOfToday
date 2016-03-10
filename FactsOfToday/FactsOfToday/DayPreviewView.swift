//
//  DayPreviewView.swift
//  FactsOfToday
//
//  Created by Evan on 3/6/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import UIKit
import AFNetworking

protocol DayPreviewDelegate {
	func didSelectRow(eventList: [Event]?)
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
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 80
		
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.reloadData()
		
		if month != nil && day != nil {
			downloadData(month!, day: day!)
		}
	}
	
	func clearData() {
		events = nil
		births = nil
		deaths = nil
		
		tableView.reloadData()
	}
	
	func reloadData(month: String, day: String) {
		self.month = month
		self.day = day
		
		events = nil
		births = nil
		deaths = nil
		
		tableView.reloadData()
		
		downloadData(month, day: day)
        
	}
    
    func reloadDataOnCalendar(month: String, day: String, view: SwipeView) {
        self.month = month
        self.day = day
        
        events = nil
        births = nil
        deaths = nil
        
        view.reloadData()
        tableView.reloadData()
        
        downloadData(month, day: day)
    }
	
	func downloadData(month: String, day: String) {
		HistoryClient.getEventsByDate(month, day: day) { (events, births, deaths) -> () in
			self.events = events
			self.births = births
			self.deaths = deaths
			self.tableView.reloadData()
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
		cell?.textLabel?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
		cell?.textLabel?.numberOfLines = 3
		
		cell?.userInteractionEnabled = true
		
		switch indexPath.section {
		case 0:
			if events != nil && events?.count > 0 {
				cell?.textLabel?.text = events![0].text
			} else if events?.count == 0 {
				cell?.accessoryType = UITableViewCellAccessoryType.None
				cell?.userInteractionEnabled = false
				cell?.textLabel?.text = "Nothing here today"
			} else {
				cell?.textLabel?.text = "Loading..."
			}
		case 1:
			if births != nil && births?.count > 0 {
				cell?.textLabel?.text = births![0].text
			} else if births?.count == 0 {
				cell?.accessoryType = UITableViewCellAccessoryType.None
				cell?.userInteractionEnabled = false
				cell?.textLabel?.text = "Nothing here today"
			} else {
				cell?.textLabel?.text = "Loading..."
			}
		case 2:
			if deaths != nil && deaths?.count > 0 {
				cell?.textLabel?.text = deaths![0].text
			} else if deaths?.count == 0 {
				cell?.accessoryType = UITableViewCellAccessoryType.None
				cell?.userInteractionEnabled = false
				cell?.textLabel?.text = "Nothing here today"
			} else {
				cell?.textLabel?.text = "Loading..."
			}
		default:
			cell?.textLabel?.text = "Something went wrong"
		}
		
		return cell!
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: false)
		switch indexPath.row {
		case 0:
			delegate?.didSelectRow(events)
		case 1:
			delegate?.didSelectRow(births)
		case 2:
			delegate?.didSelectRow(deaths)
		default: break
		}
	}
}