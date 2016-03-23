//
//  AppDelegate.swift
//  FactsOfToday
//
//  Created by Malik Browne on 3/1/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
		let defaults = NSUserDefaults.standardUserDefaults()
		
		//User has turned on notifications
		if defaults.objectForKey(SettingsViewController.notificationKey) != nil &&
			defaults.boolForKey(SettingsViewController.notificationKey) {
			
			let hour = defaults.integerForKey(SettingsViewController.notificationHour)
			let minute = defaults.integerForKey(SettingsViewController.notificationMinute)
				
				
			let currentTime = NSDate()
			let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
			let components = gregorian!.components([.Year, .Month, .Day, .Hour, .Minute], fromDate: currentTime)
			components.setValue(hour, forComponent: NSCalendarUnit.Hour)
			components.setValue(minute, forComponent: NSCalendarUnit.Minute)
			let timeToFire = gregorian!.dateFromComponents(components)
			
			let formatter = NSDateFormatter()
			formatter.dateStyle = NSDateFormatterStyle.MediumStyle
			formatter.timeStyle = NSDateFormatterStyle.MediumStyle
				
			let notification = UILocalNotification()
			notification.alertBody = "Check out what important events happened today!"
			notification.fireDate = timeToFire
			notification.timeZone = NSTimeZone.defaultTimeZone()
			notification.repeatInterval = NSCalendarUnit.Day
			UIApplication.sharedApplication().scheduleLocalNotification(notification)
		}
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


}

