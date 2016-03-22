//
//  SwipeViewController.swift
//  
//
//  Created by Malik Browne on 3/5/16.
//
//

import UIKit
import Calendar_iOS

class SwipeViewController: UIViewController, SwipeViewDelegate, SwipeViewDataSource, DayPreviewDelegate, UIPopoverPresentationControllerDelegate, CalendarViewDelegate {

    @IBOutlet weak var swipeView: SwipeView!
    var items: [AnyObject] = [AnyObject]()
    let calendarViewController: UIViewController = UIViewController()
	
	var currentDate: NSDate?
	var previousPosition = 0
    var firstLoad = true
	
	//TODO: is there a better way to do this?
	//The method for the current view being changed isn't called for the first view loaded
	var firstDate = true
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    @IBAction func onTap(sender: AnyObject) {
        let popoverMenuViewController = calendarViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = sender as? UIView
        popoverMenuViewController?.sourceRect = CGRect(x: sender.center.x - CGFloat(15), y: sender.center.y, width: CGFloat(1), height: CGFloat(1))
        presentViewController(calendarViewController, animated: true, completion: nil)
        
    }
    func createCalendarView() {
        
        let calendarView: CalendarView = CalendarView()
        calendarView.shouldShowHeaders = true
        calendarView.calendarDelegate = self;
        
        calendarViewController.modalPresentationStyle = .Popover
        calendarViewController.preferredContentSize = CGSizeMake(350, calendarView.bounds.height+12.5)
        calendarViewController.view = calendarView
        calendarViewController.view.bounds = CGRectInset(view.frame, -CGFloat(12.5), -CGFloat(15));
        
    }
    
    func didChangeCalendarDate(date: NSDate!) {
        return
    }
    
    func didDoubleTapCalendar(date: NSDate!, withType type: Int) {
        currentDate = date;
        self.dismissViewControllerAnimated(true, completion: nil)
        print(currentDate)
        let components: NSDateComponents = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: currentDate!)
        let year = components.year
        
        print(year)
        self.dismissViewControllerAnimated(true, completion: nil)

        //        let printFormatter = NSDateFormatter()
        //        printFormatter.dateFormat = "MMM, d"
        //        title = printFormatter.stringFromDate(currentDate!)
        //
        //        let formatter = NSDateFormatter()
        //        formatter.dateFormat = "M"
        //        let month = formatter.stringFromDate(currentDate!)
        //        formatter.dateFormat = "d"
        //        let day = formatter.stringFromDate(currentDate!)
        //
        //        let nibViewArray = NSBundle.mainBundle().loadNibNamed("DayPreviewView", owner: self, options: nil) as NSArray
        //        view = nibViewArray.objectAtIndex(0) as! DayPreviewView
        //        
        //        
        //        (self.view as! DayPreviewView).reloadDataOnCalendar(month, day: day, view: swipeView)
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
        self.performSegueWithIdentifier("ToDetailView", sender: eventList)
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if firstLoad {
        self.items = NSMutableArray() as [AnyObject]
        for i in 0 ..< 100 {
            items.append(Int(i))
        }
        
        if currentDate == nil {
            currentDate = NSDate()
        }
        
        swipeView.delegate = self
        swipeView.dataSource = self
        swipeView.pagingEnabled = true
        swipeView.wrapEnabled = true
        
        createCalendarView()
        firstLoad = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToDetailView" {
            let events = sender as? [Event]
            let vc = segue.destinationViewController as! DetailViewController
            vc.events = events
        }
    }
}
