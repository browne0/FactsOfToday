//
//  SwipeViewController.swift
//  
//
//  Created by Malik Browne on 3/5/16.
//
//

import UIKit

class SwipeViewController: UIViewController, SwipeViewDelegate, SwipeViewDataSource {

    @IBOutlet weak var swipeView: SwipeView!
    var items: [AnyObject] = [AnyObject]()
	
	var currentDate: NSDate?
	var previousPosition = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.items = NSMutableArray() as [AnyObject]
        for var i = 0; i < 100; i++ {
            items.append(Int(i))
        }
		
		if currentDate == nil {
			currentDate = NSDate()
		}
		
        swipeView.delegate = self
        swipeView.dataSource = self
        swipeView.pagingEnabled = true
		swipeView.wrapEnabled = true
    }
    
    func swipeView(swipeView: SwipeView!, viewForItemAtIndex index: Int, var reusingView view: UIView!) -> UIView! {
        
//        var label: UILabel? = nil
		
        if view == nil {
            
//            view = UIView(frame: self.swipeView.bounds)
//            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
//            label = UILabel(frame: view.bounds)
//            label!.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
//            label!.backgroundColor = UIColor.clearColor()
//            label!.textAlignment = .Center
//            label!.font = label!.font.fontWithSize(50)
//            label!.tag = 1
//            view.addSubview(label!)
			
			let nibViewArray = NSBundle.mainBundle().loadNibNamed("DayPreviewView", owner: self, options: nil) as NSArray
			view = nibViewArray.objectAtIndex(0) as! DayPreviewView
			
        } else {
            //get a reference to the label in the recycled view
//            label = (view.viewWithTag(1) as! UILabel)
        }
		
		print("current position: \(index), previous position: \(previousPosition)")
//		if (previousPosition + 1) % 3 > (index + 1) % 3 {
//			//Moved Backward
//			print("moved back")
//			currentDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: currentDate!, options: NSCalendarOptions(rawValue: 0))
//		
//		} else if previousPosition == index {
//			//Don't change date
//			print("no date change")
//		} else {
//			//Moved Forward
//			print("moved forward")
//			currentDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: currentDate!, options: NSCalendarOptions(rawValue: 0))
//		}
		
		
		if previousPosition == 0 && index == 2 {
			print("moved back")
			decrementDate()
		} else if previousPosition == 2 && index == 0 {
			print("moved forward")
			incrementDate()
		} else if previousPosition < index {
			print("moved forward")
			incrementDate()
		} else if previousPosition > index {
			print("moved back")
			decrementDate()
		}
		
		
		previousPosition = index
		let printFormatter = NSDateFormatter()
		printFormatter.dateFormat = "MMM, d"
		
		title = printFormatter.stringFromDate(currentDate!)
		
		let formatter = NSDateFormatter()
		formatter.dateFormat = "M"
		let month = formatter.stringFromDate(currentDate!)
		formatter.dateFormat = "d"
		let day = formatter.stringFromDate(currentDate!)
		(view as! DayPreviewView).reloadData(month, day: day)
//        label!.text = items[index].stringValue
		
        return view
    }
    
    func numberOfItemsInSwipeView(swipeView: SwipeView!) -> Int {
        return 3
    }
    
    func swipeViewItemSize(swipeView: SwipeView!) -> CGSize {
        return self.swipeView.bounds.size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func incrementDate() {
		currentDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: currentDate!, options: NSCalendarOptions(rawValue: 0))
	}
	
	func decrementDate() {
		currentDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: currentDate!, options: NSCalendarOptions(rawValue: 0))
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}