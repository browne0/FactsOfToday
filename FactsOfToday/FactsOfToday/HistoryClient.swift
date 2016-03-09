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
						let events = Event.getEventObjectsWithDictionary(responseDictionary, type: Type.EVENT)
						let births = Event.getEventObjectsWithDictionary(responseDictionary, type: Type.BIRTH)
						let deaths = Event.getEventObjectsWithDictionary(responseDictionary, type: Type.DEATH)
						completion(events: events, births: births, deaths: deaths)
						return
					}
				}
				
				completion(events: nil, births: nil, deaths: nil)
		});
		task.resume()
	}
}