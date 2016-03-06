//
//  DayPreviewView.swift
//  FactsOfToday
//
//  Created by Evan on 3/6/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import UIKit

protocol DayPreviewDelegate {
	func didSelectRow()
}

class DayPreviewView: UIView {

	@IBOutlet weak var tableView: UITableView!
	
	var delegate: DayPreviewDelegate?
	
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
	
//	init() {
//		super.init()
//	}
//	
//	required init?(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//	}

	override func awakeFromNib() {
		print("woke from nib")
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.reloadData()
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
		cell!.textLabel?.text = "test with a longer message that will hopefully wrap around to be on a new line and not cover the arrow"
		return cell!
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		let text = "test with a longer message that will hopefully wrap around to be on a new line and not cover the arrow"
		let attributedText = NSAttributedString(string: text, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(UIFont.systemFontSize())])
		
		let rect = attributedText.boundingRectWithSize(CGSizeMake(tableView.bounds.size.width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
		
		return rect.size.height + 40
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: false)
		delegate?.didSelectRow()
	}
	
	
}