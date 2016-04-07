//
//  ColorScheme.swift
//  FactsOfToday
//
//  Created by Darrell Shi on 3/27/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import Foundation

class ColorScheme {
    var alreadySet = false
    var hex: Int?
    var barTintColor: UIColor?
    var tintColor: UIColor?
    var titleColor: UIColor!
    
    static var instance: ColorScheme?
    
    static func getInstance()->ColorScheme {
        if instance == nil {
            instance = ColorScheme()
        }
        return instance!
    }
    
    func setColorScheme(barTintColor: UIColor?, tintColor: UIColor?, titleColor: UIColor) {
        self.barTintColor = barTintColor
        self.tintColor = tintColor
        self.titleColor = titleColor
        alreadySet = true
    }
    
    func setToDefault() {
        barTintColor = nil
        tintColor = nil
        titleColor = UIColor.blackColor()
    }
}