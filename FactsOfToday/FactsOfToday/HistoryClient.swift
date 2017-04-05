//
//  HistoryAPI.swift
//  FactsOfToday
//
//  Created by Evan on 3/8/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import AFNetworking

class HistoryClient {
	
	class func getEventsByDate(month: String, day: String, completion: (events: [Event]?, births: [Event]?, deaths: [Event]?) -> ()) {
		let url = NSURL(string: "http://history.muffinlabs.com/date/\(month)/\(day)")
		let request = NSURLRequest(URL: url!)
		let session = NSURLSession(
			configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
			delegate: nil,
			delegateQueue:  NSOperationQueue.mainQueue()
		)
		
		let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
			completionHandler: { (dataOrNil, response, error) in
				if error != nil {
					print("retrieving information for date:\n\(error?.localizedDescription)")
					completion(events: nil, births: nil, deaths: nil)
					return
				}
				
				if let data = dataOrNil {
					if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
                        
                        if let unsortedEvents = responseDictionary["data"]!["Events"] as? NSArray {
                            let descriptor = NSSortDescriptor(key: "year", ascending: false, comparator: { (obj1, obj2) -> NSComparisonResult in
                                if (obj1.integerValue > obj2.integerValue) {
                                    return NSComparisonResult.OrderedDescending
                                }
                                if (obj1.integerValue < obj2.integerValue) {
                                    return NSComparisonResult.OrderedAscending
                                }
                                
                                return NSComparisonResult.OrderedSame
                                
                            })
                            let events: NSArray = unsortedEvents.sortedArrayUsingDescriptors([descriptor])
                            
                            
                            for i in 0 ..< events.count {
                                var dictResult = events.objectAtIndex(i) as! NSDictionary
                            }
                            

                            
                        }
                        
                        
						let events2 = Event.getEventObjectsWithDictionary(responseDictionary, type: Type.EVENT)
						let births = Event.getEventObjectsWithDictionary(responseDictionary, type: Type.BIRTH)
						let deaths = Event.getEventObjectsWithDictionary(responseDictionary, type: Type.DEATH)
						completion(events: events2, births: births, deaths: deaths)
						return
					}
				}
				
				completion(events: nil, births: nil, deaths: nil)
		});
		task.resume()
	}
	
	
	static let Failure = 0
	static let Success = 1
	static let AlreadyCached = 2
	static let notCaching = 3
	//Grabs the data for the given day
	class func cacheEvent(completion: ((Int) -> ())? ) {
		let defaults = NSUserDefaults.standardUserDefaults()
		
		//If the user has notifications turned off, no reason to cache anything.
		if defaults.objectForKey(SettingsViewController.notificationKey) == nil ||
			!defaults.boolForKey(SettingsViewController.notificationKey) {
			completion?(HistoryClient.notCaching)
			return
		}
		
		let currentDate = NSDate()
		let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
		let formatter = NSDateFormatter()
		formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
		
		//Check whether we are before or after the user's notification time.
		//If before, get the facts for today. If after, get the facts for tomorrow
		let notificationTimeString = defaults.stringForKey(SettingsViewController.notificationTime)!
		formatter.dateFormat = "H:m"
		let notificationTime = formatter.dateFromString(notificationTimeString)!
		
		let currentComponents = calendar?.components([.Hour, .Minute], fromDate: currentDate)
		let notificationComponents = calendar?.components([.Hour, .Minute], fromDate: notificationTime)
		
		let truncatedCurrent = calendar?.dateFromComponents(currentComponents!)
		let truncatedNotification = calendar?.dateFromComponents(notificationComponents!)
		
		let result = truncatedCurrent?.compare(truncatedNotification!)
		
		
		
		var dateToRefresh: NSDate!
		
		//Current time is earlier in the day than the notification
		if result == NSComparisonResult.OrderedAscending {
			let dateComponents = calendar?.components([.Month, .Day], fromDate: currentDate)
			dateToRefresh = calendar?.dateFromComponents(dateComponents!)
			
		//Current time is equal to or later than the notification
		} else {
			let nextDate = calendar?.dateByAddingUnit(.Day, value: 1, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))
			let dateComponents = calendar?.components([.Month, .Day], fromDate: nextDate!)
			dateToRefresh = calendar?.dateFromComponents(dateComponents!)
		}
		
		//Check whether or not we have cached a value previously
		if defaults.objectForKey(SettingsViewController.notificationLastUpdate) != nil {
			let lastUpdateString = defaults.stringForKey(SettingsViewController.notificationLastUpdate)
			formatter.dateFormat = "M/d"
			
			let refreshDateString = formatter.stringFromDate(dateToRefresh)
			
			//If we have cached info on the same day as the next refresh we don't have to get events again
			if lastUpdateString == refreshDateString {
				print("already cached")
				completion?(HistoryClient.AlreadyCached)
				return
			}
			
		}
		
		
		
		formatter.dateFormat = "M"
		let month = formatter.stringFromDate(dateToRefresh)
		
		formatter.dateFormat = "d"
		let day = formatter.stringFromDate(dateToRefresh)
		
		let url = NSURL(string: "http://history.muffinlabs.com/date/\(month)/\(day)")
		let request = NSURLRequest(URL: url!)
		let session = NSURLSession(
			configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
			delegate: nil,
			delegateQueue:  NSOperationQueue.mainQueue()
		)
		
		let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
		  completionHandler: { (dataOrNil, response, error) in
			if error != nil {
				print("retrieving information to cache:\n\(error?.localizedDescription)")
				completion?(HistoryClient.Failure)
				return
			}
			
			if let data = dataOrNil {
				if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
					let events = Event.getEventObjectsWithDictionary(responseDictionary, type: Type.EVENT)
					
					if events == nil || events?.count == 0 {
						return
					}
					
					let defaults = NSUserDefaults.standardUserDefaults()
					
					let cacheDate = month + "/" + day
					
					defaults.setObject(cacheDate, forKey: SettingsViewController.notificationLastUpdate)
					defaults.setObject(events![0].text, forKey: SettingsViewController.notificationDescription)
					
					print("saved stuff")
					
					completion?(HistoryClient.Success)
					return
				}
			}
		});
		task.resume()
	}
}

private func convertJsonObjectToDictionary(arrayElement: AnyObject) -> [String:AnyObject]? {
    if let data = arrayElement.dataUsingEncoding(NSUTF8StringEncoding) {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
        } catch let error as NSError {
            print(error)
        } catch {
            print("error converting dictionary")
        }
    }
    return nil
}