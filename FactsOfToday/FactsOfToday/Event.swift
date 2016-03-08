//
//  Event.swift
//  FactsOfToday
//
//  Created by Darrell Shi on 3/5/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import Foundation

enum Type {
    case EVENT
    case BIRTH
    case DEATH
}

class Event {
    var time: NSDate!
    var text: String?
    var links: [Link]?
    var type: Type!
    
    // time should be of format "December 25 2016"
    init(time: String, text: String?, type: Type) {
        self.time = getTimeWithString(time)
        self.text = text        
    }
    
    private func getTimeWithString(dateString: String)->NSDate! {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM d yyyy"
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        let date = formatter.dateFromString(dateString)!
        return date
    }
    
    // all types are force unwrapped
    // more testing needed
    func getEventObjectsWithDictionary(dictionary: NSDictionary, type: Type)->[Event]? {
        let date = dictionary["date"] as? String
        var events_dic: [NSDictionary]
        if type == Type.EVENT {
            events_dic = (dictionary["data"] as! NSDictionary)["Events"] as! [NSDictionary]
        } else if type == Type.BIRTH {
            events_dic = (dictionary["data"] as! NSDictionary)["Births"] as! [NSDictionary]
        } else {
            events_dic = (dictionary["data"] as! NSDictionary)["Deaths"] as! [NSDictionary]
        }
        
        var events = [Event]()
        for event_dic in events_dic {
            let year = event_dic["year"] as? String
            let event = Event(time: "\(date) \(year)", text: event_dic["text"] as? String, type: type)
            let links_dic = event_dic["links"] as! [NSDictionary]
            var links = [Link]()
            for link_dic in links_dic {
                let link = Link(subject: link_dic["subject"] as? String, title: link_dic["title"] as? String, url: link_dic["link"] as? String)
                links.append(link)
            }
            event.links = links
            events.append(event)
        }
        
        return events
    }
}