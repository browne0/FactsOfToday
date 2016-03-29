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
    var statusBarStyle = UIStatusBarStyle.Default
    
    static var instance: ColorScheme?
    
    static func getInstance()->ColorScheme {
        if instance == nil {
            instance = ColorScheme()
        }
        return instance!
    }
    
    init() {
        
    }
    
    func setColorScheme(barTintColor: UIColor?, tintColor: UIColor?, titleColor: UIColor, statusBarStyle: UIStatusBarStyle) {
        self.barTintColor = barTintColor
        self.tintColor = tintColor
        self.titleColor = titleColor
        self.statusBarStyle = statusBarStyle
        alreadySet = true
    }
    
    func setToDefault() {
        barTintColor = nil
        tintColor = nil
        titleColor = UIColor.blackColor()
        statusBarStyle = UIStatusBarStyle.Default
    }
}