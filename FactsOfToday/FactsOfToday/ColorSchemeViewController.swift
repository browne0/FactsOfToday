//
//  ColorSchemeViewController.swift
//  FactsOfToday
//
//  Created by Darrell Shi on 3/27/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import UIKit

class ColorSchemeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    var colors: [UIColor]!
    var delegate: ColorSchemeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        colors = [UIColor]()
        colors.append(UIColor(red: 133/255, green: 174/255, blue: 38/255, alpha: 1))
        colors.append(UIColor(red: 251/255, green: 81/255, blue: 68/255, alpha: 1))
        colors.append(UIColor(netHex: 0x338acc))
        colors.append(UIColor(netHex: 0x936798))
        colors.append(UIColor(netHex: 0xe89726))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let colorScheme = ColorScheme.getInstance()
        colorScheme.setColorScheme(colors[indexPath.row], tintColor: UIColor.whiteColor())
        let nb = self.navigationController?.navigationBar
        nb?.barTintColor = colorScheme.barTintColor
        nb?.titleTextAttributes = [NSForegroundColorAttributeName : colorScheme.tintColor!]
        nb?.tintColor = colorScheme.tintColor
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ColorCell", forIndexPath: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        return cell
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