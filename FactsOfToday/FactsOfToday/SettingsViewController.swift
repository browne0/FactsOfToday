//
//  SettingsViewController.swift
//  FactsOfToday
//
//  Created by Evan on 3/19/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import UIKit

class SettingsViewController: StaticDataTableViewController {
	
	static let notificationKey = "useNotifications"
	static let notificationHour = "notificationHour"
	static let notificationMinute = "notificationMinute"
	var timePickerHidden = true
	
	@IBOutlet var settingsTableView: UITableView!
	@IBOutlet weak var notificationSwitch: UISwitch!
	@IBOutlet weak var timeCell: UITableViewCell!
	@IBOutlet weak var notificationTimeLabel: UILabel!
	@IBOutlet weak var timePickerCell: UITableViewCell!
	@IBOutlet weak var notificationTimePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		insertTableViewRowAnimation = UITableViewRowAnimation.Middle
		deleteTableViewRowAnimation = UITableViewRowAnimation.Middle
		reloadTableViewRowAnimation = UITableViewRowAnimation.Middle
		
		let defaults = NSUserDefaults.standardUserDefaults()

		let showTime = defaults.boolForKey(SettingsViewController.notificationKey)
		notificationSwitch.setOn(showTime, animated: false)
		if !showTime {
			cell(timeCell, setHidden: true)
		}
		cell(timePickerCell, setHidden: true)
		reloadDataAnimated(false)
		
		notificationTimePicker.addTarget(self, action: "dateChanged:", forControlEvents: UIControlEvents.ValueChanged)
		
		if defaults.objectForKey(SettingsViewController.notificationHour) == nil {
			let currentTime = NSDate()
			
			let formatter = NSDateFormatter()
			formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
			formatter.dateFormat = "m"
			let minutes = Int(formatter.stringFromDate(currentTime))
			let remainder = (minutes! % 5) * -1
			
			let roundedTime = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Minute, value: remainder, toDate: currentTime, options: NSCalendarOptions(rawValue: 0))
			
			notificationTimePicker.date = roundedTime!
			
			formatter.locale = NSLocale.currentLocale()
			formatter.dateStyle = NSDateFormatterStyle.NoStyle
			formatter.timeStyle = NSDateFormatterStyle.ShortStyle
			
			notificationTimeLabel.text = formatter.stringFromDate(roundedTime!)
		} else {
			let hour = defaults.integerForKey(SettingsViewController.notificationHour)
			let minute = defaults.integerForKey(SettingsViewController.notificationMinute)
			
			let currentTime = NSDate()
			let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
			let components = gregorian?.components([.Hour, .Minute], fromDate: currentTime)
			components?.setValue(hour, forComponent: NSCalendarUnit.Hour)
			components?.setValue(minute, forComponent: NSCalendarUnit.Minute)
			let savedTime = gregorian?.dateFromComponents(components!)
			
			notificationTimePicker.date = savedTime!
			
			let formatter = NSDateFormatter()
			formatter.dateStyle = NSDateFormatterStyle.NoStyle
			formatter.timeStyle = NSDateFormatterStyle.ShortStyle
			
			notificationTimeLabel.text = formatter.stringFromDate(savedTime!)
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func dateChanged(datePicker: UIDatePicker) {
		let formatter = NSDateFormatter()
//		formatter.dateFormat = "H"
		formatter.dateStyle = NSDateFormatterStyle.NoStyle
		formatter.timeStyle = NSDateFormatterStyle.ShortStyle
		notificationTimeLabel.text = formatter.stringFromDate(datePicker.date)
	}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	override func viewWillDisappear(animated: Bool) {
		let defaults = NSUserDefaults.standardUserDefaults()
		defaults.setBool(notificationSwitch.on, forKey: SettingsViewController.notificationKey)
		
		if notificationSwitch.on {
			let formatter = NSDateFormatter()
			formatter.dateFormat = "H"
			defaults.setInteger(
				Int(formatter.stringFromDate(notificationTimePicker.date))!,
				forKey: SettingsViewController.notificationHour)
			
			formatter.dateFormat = "m"
			defaults.setInteger(
				Int(formatter.stringFromDate(notificationTimePicker.date))!,
				forKey: SettingsViewController.notificationMinute)
		} else {
//			defaults.removeObjectForKey(SettingsViewController.notificationHour)
//			defaults.removeObjectForKey(SettingsViewController.notificationMinute)
		}
		
	}
	
	@IBAction func onNotificationSwitched(sender: UISwitch) {
		UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert], categories: nil))
		
		timePickerHidden = true
		
		cell(timeCell, setHidden: !sender.on)
		cell(timePickerCell, setHidden: true)
		reloadDataAnimated(true)
	}
	
	@IBAction func didPressDone(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: false)
		
		if indexPath.section == 1 && indexPath.row == 1 {
			cell(timePickerCell, setHidden: !timePickerHidden)
			timePickerHidden = !timePickerHidden
			reloadDataAnimated(true)
		}
	}
}
