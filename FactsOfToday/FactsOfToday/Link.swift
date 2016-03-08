//
//  Link.swift
//  FactsOfToday
//
//  Created by Darrell Shi on 3/5/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import Foundation

class Link {
    var subject: String?
    var title: String?
    var url: NSURL?
    
    init(subject: String?, title: String?, url: String?) {
        self.subject = subject
        self.title = title
        if let url = url {
            self.url = NSURL(string: url)
        }
    }
}