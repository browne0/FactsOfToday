//
//  ColorSchemeViewController.swift
//  FactsOfToday
//
//  Created by Darrell Shi on 3/27/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import UIKit

let ColorSchemeKey = "ColorSchemeKey"

class ColorSchemeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    var colors: [Int]!
    var delegate: ColorSchemeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        colors = [Int]()
        colors.append(0xFFFFFF)
        colors.append(0x85AE26)
        colors.append(0xFB5144)
        colors.append(0x338acc)
        colors.append(0x936798)
        colors.append(0xe89726)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let colorScheme = ColorScheme.getInstance()
        let nb = self.navigationController?.navigationBar
        if indexPath.row == 0 {
            colorScheme.setToDefault()
        } else {
            colorScheme.setColorScheme(UIColor(netHex: colors[indexPath.row]), tintColor: UIColor.whiteColor(), titleColor: UIColor.whiteColor(), statusBarStyle: UIStatusBarStyle.LightContent)
        }
        colorScheme.alreadySet = false
        nb?.barTintColor = colorScheme.barTintColor
        nb?.titleTextAttributes = [NSForegroundColorAttributeName : colorScheme.titleColor]
        nb?.tintColor = colorScheme.tintColor
        UIApplication.sharedApplication().setStatusBarStyle(colorScheme.statusBarStyle, animated: false)
        NSUserDefaults.standardUserDefaults().setInteger(colors[indexPath.row], forKey: ColorSchemeKey)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ColorCell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor(netHex: colors[indexPath.row])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let numberOfCellInRow : Int = 2
        let padding : Int = 4
        let collectionCellWidth : CGFloat = (self.view.frame.size.width/CGFloat(numberOfCellInRow))
        return CGSize(width: collectionCellWidth , height: collectionCellWidth)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}