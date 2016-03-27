//
//  ColorScheme.swift
//  FactsOfToday
//
//  Created by Darrell Shi on 3/27/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import Foundation

class ColorScheme {
    var customized = false
    var barTintColor: UIColor?
    var tintColor: UIColor?
    static var instance: ColorScheme?
    
    static func getInstance()->ColorScheme {
        if instance == nil {
            instance = ColorScheme()
        }
        return instance!
    }
    
    init() {
        
    }
    
    func setColorScheme(barTintColor: UIColor, tintColor: UIColor) {
        self.barTintColor = barTintColor
        self.tintColor = tintColor
        customized = true
    }
}