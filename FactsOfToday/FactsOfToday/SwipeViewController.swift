//
//  SwipeViewController.swift
//  
//
//  Created by Malik Browne on 3/5/16.
//
//

import UIKit

class SwipeViewController: UIViewController, SwipeViewDelegate, SwipeViewDataSource, DayPreviewDelegate {

    @IBOutlet weak var swipeView: SwipeView!
    var items: [AnyObject] = [AnyObject]()
	
	var currentDate: NSDate?
	var previousPosition = 0
	
	//TODO: is there a better way to do this?
	//The method for the current view being changed isn't called for the first view loaded
	var firstDate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.items = NSMutableArray() as [AnyObject]
        for var i = 0; i < 100; i++ {
            items.append(Int(i))
        }
        
        swipeView.delegate = self
        swipeView.dataSource = self
        swipeView.pagingEnabled = true
    }
    
    func swipeView(swipeView: SwipeView!, viewForItemAtIndex index: Int, var reusingView view: UIView!) -> UIView! {
		
        if view == nil {
			let nibViewArray = NSBundle.mainBundle().loadNibNamed("DayPreviewView", owner: self, options: nil) as NSArray
			view = nibViewArray.objectAtIndex(0) as! DayPreviewView
			
			(view as! DayPreviewView).delegate = self
        }
		
		if firstDate {
			firstDate = false
			
			let printFormatter = NSDateFormatter()
			printFormatter.dateFormat = "MMM, d"
			title = printFormatter.stringFromDate(currentDate!)
			
			let formatter = NSDateFormatter()
			formatter.dateFormat = "M"
			let month = formatter.stringFromDate(currentDate!)
			formatter.dateFormat = "d"
			let day = formatter.stringFromDate(currentDate!)
			(view as! DayPreviewView).reloadData(month, day: day)
		} else {
			(view as! DayPreviewView).clearData()
		}
		
		
        return view
    }
	
	func swipeViewCurrentItemIndexDidChange(swipeView: SwipeView!) {
		let index = swipeView.currentItemIndex
		let view = swipeView.itemViewAtIndex(index)
		
		if previousPosition == 0 && index == 2 {
			decrementDate()
		} else if previousPosition == 2 && index == 0 {
			incrementDate()
		} else if previousPosition < index {
			incrementDate()
		} else if previousPosition > index {
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
	
	func didSelectRow(eventList: [Event]?) {
		//TODO: open list to show more events and pass this data
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

extension SwipeViewController: DayPreviewDelegate {
    func didSelectRow(indexPath: NSIndexPath) {
        print("delegate called")
        self.performSegueWithIdentifier("ToDetailView", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToDetailView" {
            let indexPath = sender as! NSIndexPath
//            let vc = segue.destinationViewController as! DetailViewController
            print(indexPath.section)
//            vc.events
        }
    }
}