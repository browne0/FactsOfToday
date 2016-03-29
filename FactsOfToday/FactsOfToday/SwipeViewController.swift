//
//  SwipeViewController.swift
//  
//
//  Created by Malik Browne on 3/5/16.
//
//

import UIKit
import CVCalendar

class SwipeViewController: UIViewController, SwipeViewDelegate, SwipeViewDataSource, DayPreviewDelegate, UIPopoverPresentationControllerDelegate  {

    @IBOutlet weak var swipeView: SwipeView!
    var items: [AnyObject] = [AnyObject]()
    let calendarViewController: UIViewController = UIViewController()
	
	var currentDate: NSDate?
	var previousPosition = 0
    var selectedDay: DayView!
	
    var calendarView: CVCalendarView!
    var menuView: CVCalendarMenuView!
    
	//TODO: is there a better way to do this?
	//The method for the current view being changed isn't called for the first view loaded
	var firstDate = true
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    @IBAction func onCalendarPress(sender: AnyObject) {
        let popoverMenuViewController = calendarViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = sender as? UIView
        popoverMenuViewController?.sourceRect = CGRect(x: sender.center.x - CGFloat(15), y: sender.center.y, width: CGFloat(1), height: CGFloat(1))
        presentViewController(calendarViewController, animated: false, completion: nil)
    }
    
    func createCalendarView() {
        
        // CVCalendarView initialization with frame
        self.calendarView = CVCalendarView(frame: CGRectMake(0, 20, 300, 450))
        
        // CVCalendarMenuView initialization with frame
        self.menuView = CVCalendarMenuView(frame: CGRectMake(0, 90, 300, 15))
        
        // Calendar delegate
        self.calendarView.calendarDelegate = self
        
        // Menu delegate
        self.menuView.menuViewDelegate = self
        
        calendarViewController.modalPresentationStyle = .Popover
//        calendarViewController.preferredContentSize = CGSizeMake(350, calendarView.bounds.height)
        calendarViewController.view = calendarView
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.calendarView.commitCalendarViewUpdate()
        self.menuView.commitMenuViewUpdate()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToDetailView" {
            let events = sender as? [Event]
            let vc = segue.destinationViewController as! DetailViewController
            vc.events = events
        }
    }
}

extension SwipeViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    func didSelectDayView(dayView: DayView, animationDidFinish: Bool) {
        print("\(dayView.date.commonDescription) is selected!")
        selectedDay = dayView
        
        dismissViewControllerAnimated(true, completion: nil)
        
        let selectedDate =  dayView.date.convertedDate()
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        let componentsCurrentDate = calendar?.components([.Year,.Month,.Day], fromDate: currentDate!)
        
        let componentsSelectedDate = calendar?.components([.Year,.Month,.Day], fromDate: selectedDate!)
        
        componentsCurrentDate?.setValue((componentsSelectedDate?.month)!, forComponent: NSCalendarUnit.Month)
        
        componentsCurrentDate?.setValue((componentsSelectedDate?.day)!, forComponent: NSCalendarUnit.Day)
        
        currentDate = calendar!.dateFromComponents(componentsCurrentDate!)
        
        let printFormatter = NSDateFormatter()
        printFormatter.dateFormat = "MMM, d"
        
        title = printFormatter.stringFromDate((currentDate)!)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M"
        let month = formatter.stringFromDate(currentDate!)
        formatter.dateFormat = "d"
        let day = formatter.stringFromDate(currentDate!)
        
        if view != nil {
            (swipeView.currentItemView as! DayPreviewView).reloadData(month, day: day)
        } 
    }
}