//
//  AppDelegate.swift
//  FactsOfToday
//
//  Created by Malik Browne on 3/1/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
//        let notificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
//        let notificationSettings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
//        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        FIRApp.configure()
        
        return true
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings)
    {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
//        print("Device Token:", tokenString)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
		scheduleNotification()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
		UIApplication.sharedApplication().cancelAllLocalNotifications()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

	func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
		HistoryClient.cacheEvent {
			(statusCode) in
			
			print("got data in background")
			switch statusCode {
			case HistoryClient.Success:
				NSUserDefaults.standardUserDefaults().synchronize()
				self.scheduleNotification()
				
				completionHandler(UIBackgroundFetchResult.NewData)
			case HistoryClient.AlreadyCached:
				completionHandler(UIBackgroundFetchResult.NoData)
			case HistoryClient.notCaching:
				completionHandler(UIBackgroundFetchResult.NoData)
			case HistoryClient.Failure:
				completionHandler(UIBackgroundFetchResult.Failed)
			default:	//This shouldn't happen
				completionHandler(UIBackgroundFetchResult.Failed)
			}
		}
	}
	
	func scheduleNotification() {
		let defaults = NSUserDefaults.standardUserDefaults()
		
		//User has turned on notifications
		if defaults.objectForKey(SettingsViewController.notificationKey) != nil &&
			defaults.boolForKey(SettingsViewController.notificationKey) {
			
			let formatter = NSDateFormatter()
			formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
			formatter.timeZone = NSTimeZone.defaultTimeZone()
			formatter.dateFormat = "H:m"
			
			let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
			let currentTime = NSDate()
			
			
			//Compare the current time and notification time to see if the notification should be scheduled for the next day
			let notificationTimeString = defaults.stringForKey(SettingsViewController.notificationTime)!
			let notificationTime = formatter.dateFromString(notificationTimeString)!
			
			let currentComponents = calendar?.components([.Hour, .Minute], fromDate: currentTime)
			let notificationComponents = calendar?.components([.Hour, .Minute], fromDate: notificationTime)
			
			let truncatedCurrent = calendar?.dateFromComponents(currentComponents!)
			let truncatedNotification = calendar?.dateFromComponents(notificationComponents!)
			
			let result = truncatedCurrent?.compare(truncatedNotification!)
			
			var addDay: Bool
			//Current time is earlier in the day than the notification
			if result == NSComparisonResult.OrderedAscending {
				addDay = false
				
				//Current time is equal to or later than the notification
			} else {
				addDay = true
			}
			
			
			
			let hourMinute = notificationTimeString.characters.split{$0 == ":"}.map(String.init)
			
			let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
			let components = gregorian!.components([.Year, .Month, .Day, .Hour, .Minute], fromDate: currentTime)
			components.setValue(Int(hourMinute[0])!, forComponent: NSCalendarUnit.Hour)
			components.setValue(Int(hourMinute[1])!, forComponent: NSCalendarUnit.Minute)
			var timeToFire = gregorian!.dateFromComponents(components)
			
			if addDay {
				timeToFire = calendar?.dateByAddingUnit(.Day, value: 1, toDate: timeToFire!, options: NSCalendarOptions(rawValue: 0))
			}
			
			
			
//			formatter.dateStyle = NSDateFormatterStyle.NoStyle
//			formatter.timeStyle = NSDateFormatterStyle.FullStyle
//			print("scheduling for: \(formatter.stringFromDate(timeToFire!))")
			
			let notification = UILocalNotification()
			notification.alertBody = getCachedMessage()
			notification.fireDate = timeToFire
            notification.soundName = UILocalNotificationDefaultSoundName
			notification.timeZone = NSTimeZone.defaultTimeZone()
//			notification.repeatInterval = NSCalendarUnit.Day
			UIApplication.sharedApplication().scheduleLocalNotification(notification)
		}

	}
	
	func getCachedMessage() -> String {
		let defaults = NSUserDefaults.standardUserDefaults()
		
		let formatter = NSDateFormatter()
		formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
		formatter.dateFormat = "M/d"
		
		let currentDate = NSDate()
		let currentDateString = formatter.stringFromDate(currentDate)
		
		//If we have a cached event description for today, return it
		if defaults.objectForKey(SettingsViewController.notificationLastUpdate) != nil &&
				defaults.stringForKey(SettingsViewController.notificationLastUpdate) == currentDateString {
			
			return "Interesting fact: The " + defaults.stringForKey(SettingsViewController.notificationDescription)! + " Find out more interesting things on Facts Of Today!"
		} else {
            let randPromptIndex = Int(arc4random_uniform(4))
            switch (randPromptIndex) {
            case 0:
                return "Want to learn a cool new fact? Check out what interesting events happened today!"
            case 1:
                return "Come and explore in Facts of Today to find out what interesting events happened today!"
            case 2:
                return "It's about that time! Come and check out what different events happened today on Facts Of Today!"
            case 3:
                return "Ever wondered what happened today in history? Come find out on Facts of Today!"
            default:
                return "Come and expand your knowledge on what happened today in history on Facts of Today!"
            }
            
			
		}
	}

}

