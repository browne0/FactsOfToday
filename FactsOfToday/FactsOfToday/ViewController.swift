//
//  ViewController.swift
//  FactsOfToday
//
//  Created by Malik Browne on 3/1/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		let nibViewArray = NSBundle.mainBundle().loadNibNamed("DayPreviewView", owner: self, options: nil) as NSArray
		let dayPreview = nibViewArray.objectAtIndex(0) as! DayPreviewView
		view.addSubview(dayPreview)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

