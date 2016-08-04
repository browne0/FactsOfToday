//
//  SwipeViewController.swift
//  
//
//  Created by Malik Browne on 3/5/16.
//
//

import UIKit
import CVCalendar
import GoogleMobileAds

let selectedDateKey = "selectedDateKey"
let setDateKey = "setDateKey"

protocol ColorSchemeDelegate {
    func didChangeColorScheme(barTintColor: UIColor, tintColor: UIColor)
}

class SwipeViewController: UIViewController, SwipeViewDelegate, SwipeViewDataSource, DayPreviewDelegate, UIPopoverPresentationControllerDelegate, ColorSchemeDelegate  {
    @IBOutlet weak var bannerView: GADBannerView!

    @IBOutlet weak var swipeView: SwipeView!
    
    
    var items: [AnyObject] = [AnyObject]()
    let calendarViewController: UIViewController = UIViewController()
	
	var currentDate: CVDate?
	var previousPosition = 0
    var selectedDay: DayView!
	
    var calendarView: CVCalendarView!
    var menuView: CVCalendarMenuView!
    
    var dateLabel: UILabel!
    var todayButton: UIButton!
    var animationFinished = true
    
    var barTintColor: UIColor?
    var tintColor: UIColor?
        
	//TODO: is there a better way to do this?
	//The method for the current view being changed isn't called for the first view loaded
	var firstDate = true
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    func loadAd() {
        bannerView.adUnitID = "ca-app-pub-7283739744398858/4506715724"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
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
        self.calendarView = CVCalendarView(frame: CGRectMake(0, 90, calendarViewController.view.frame.size.width-16, 350))
        
        // CVCalendarMenuView initialization with frame
        self.menuView = CVCalendarMenuView(frame: CGRectMake(0, 60, calendarViewController.view.frame.size.width-16, 15))
        
        
        // DateLabel initilization with frame
        dateLabel = UILabel(frame: CGRectMake(0, 0, 300, 21))
        dateLabel.center = CGPointMake(calendarView.center.x, 25)
        dateLabel.textAlignment = NSTextAlignment.Center
        dateLabel.font = dateLabel.font.fontWithSize(22)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM"
        
        let convertedDate = currentDate?.convertedDate()
        
        dateLabel.text = dateFormatter.stringFromDate(convertedDate!)
        
        // Today button initialization with frame
        todayButton = UIButton(frame: CGRectMake(0, 0, 26, 26))
        todayButton.tintColor = UIColor.blueColor()
        todayButton.center = CGPointMake(calendarViewController.view.frame.size.width-42, 25)
        let todayButtonImage = UIImage(named: "todayButton")!.imageWithRenderingMode(.AlwaysTemplate)
        todayButton.setBackgroundImage(todayButtonImage, forState: .Normal)
        todayButton.addTarget(self, action: #selector(SwipeViewController.onTodayPress(_:)), forControlEvents: .TouchUpInside)
        
        // Calendar delegate
        self.calendarView.calendarDelegate = self
        
        // Menu delegate
        self.menuView.menuViewDelegate = self
        
        calendarViewController.modalPresentationStyle = .Popover
        calendarViewController.preferredContentSize = CGSizeMake(self.view.frame.size.width-8,  (calendarView.bounds.height + menuView.bounds.height + 25))
        let calendarViewFinal = calendarViewController.view
        calendarViewFinal.addSubview(calendarView)
        calendarViewFinal.addSubview(menuView)
        calendarViewFinal.addSubview(dateLabel)
        calendarViewFinal.addSubview(todayButton)
    }
    
    func swipeView(swipeView: SwipeView!, viewForItemAtIndex index: Int, reusingView: UIView!) -> UIView! {
		var view = reusingView
        if view == nil {
			let nibViewArray = NSBundle.mainBundle().loadNibNamed("DayPreviewView", owner: self, options: nil) as NSArray
			view = nibViewArray.objectAtIndex(0) as! DayPreviewView
			
			(view as! DayPreviewView).delegate = self
        }
		
		if firstDate {
			firstDate = false
			
			let printFormatter = NSDateFormatter()
			printFormatter.dateFormat = "MMM, d"
            
            let convertedDate = currentDate?.convertedDate()
			title = printFormatter.stringFromDate(convertedDate!)
            
			
			let formatter = NSDateFormatter()
			formatter.dateFormat = "M"
			let month = formatter.stringFromDate(convertedDate!)
			formatter.dateFormat = "d"
			let day = formatter.stringFromDate(convertedDate!)
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
        let convertedDate = currentDate?.convertedDate()
		
		title = printFormatter.stringFromDate(convertedDate!)
		
		let formatter = NSDateFormatter()
		formatter.dateFormat = "M"
		let month = formatter.stringFromDate(convertedDate!)
		formatter.dateFormat = "d"
		let day = formatter.stringFromDate(convertedDate!)
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
    
    private func saveLocally() {
        let convertedDate = currentDate?.convertedDate()
        NSUserDefaults.standardUserDefaults().setObject(convertedDate, forKey: selectedDateKey)
        NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: setDateKey)
    }
    
    private func readSelectedDate() {
        if let setDate = NSUserDefaults.standardUserDefaults().objectForKey(setDateKey) as? NSDate{
                let setDateString = setDate.getDate()
                let currentDateString = NSDate().getDate()
                if setDateString == currentDateString {
                    let selectedDate = NSUserDefaults.standardUserDefaults().objectForKey(selectedDateKey) as? NSDate
                    currentDate = CVDate(date: selectedDate!)
                }
        }
    }
    
    func incrementDate() {
        var convertedDate = currentDate?.convertedDate()
		convertedDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: convertedDate!, options: NSCalendarOptions(rawValue: 0))
        
        currentDate = CVDate(date: convertedDate!)
        saveLocally()
	}
	
	func decrementDate() {
        var convertedDate = currentDate?.convertedDate()
		convertedDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: convertedDate!, options: NSCalendarOptions(rawValue: 0))
        
        currentDate = CVDate(date: convertedDate!)
        saveLocally()
	}
	
	func didSelectRow(eventList: [Event]?) {
        self.performSegueWithIdentifier("ToDetailView", sender: eventList)
	}
    
    func setColorScheme() {
        let colorHex = NSUserDefaults.standardUserDefaults().integerForKey(ColorSchemeKey)

        ColorScheme.getInstance().setColorScheme(UIColor(netHex: colorHex), tintColor: UIColor.whiteColor(), titleColor: UIColor.whiteColor())

        ColorScheme.getInstance().alreadySet = false
        
        viewWillAppear(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        let colorScheme = ColorScheme.getInstance()
        if !colorScheme.alreadySet {
            let nb = self.navigationController?.navigationBar
            nb?.barTintColor = colorScheme.barTintColor
            nb?.titleTextAttributes = [NSForegroundColorAttributeName : colorScheme.titleColor]
            nb?.tintColor = colorScheme.tintColor
            todayButton.tintColor = colorScheme.barTintColor
            colorScheme.alreadySet = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAd()
        readSelectedDate()
        
        self.items = NSMutableArray() as [AnyObject]
        for i in 0 ..< 100 {
            items.append(Int(i))
        }
        
        if currentDate == nil {
            currentDate = CVDate(date: NSDate())
        }
        
        createCalendarView()
        setColorScheme()
        
        swipeView.delegate = self
        swipeView.dataSource = self
        swipeView.pagingEnabled = true
        swipeView.wrapEnabled = true
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
    
    func didChangeColorScheme(barTintColor: UIColor, tintColor: UIColor) {
        self.barTintColor = barTintColor
        self.tintColor = tintColor
    }
}

extension SwipeViewController {
    
    func onTodayPress(sender: AnyObject) {
        calendarView.toggleCurrentDayView()
    }

}

extension SwipeViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        bannerView.alpha = 0
        UIView.animateWithDuration(1, animations:  {
            bannerView.alpha = 1
        })
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
    
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }
    
    func presentedDateUpdated(date: Date) {
        let convertedDate = date.convertedDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let monthCheck = dateFormatter.stringFromDate(convertedDate!)
        
        if dateLabel.text != monthCheck && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = dateLabel.textColor
            updatedMonthLabel.font = dateLabel.font
            updatedMonthLabel.textAlignment = .Center
            
            let convertedDate = date.convertedDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMMM"
            
            updatedMonthLabel.text = dateFormatter.stringFromDate(convertedDate!)
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.dateLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
            updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
            
            UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.animationFinished = false
                self.dateLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
                self.dateLabel.transform = CGAffineTransformMakeScale(1, 0.1)
                self.dateLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransformIdentity
                
                }) { _ in
                    
                    self.animationFinished = true
                    self.dateLabel.frame = updatedMonthLabel.frame
                    self.dateLabel.text = updatedMonthLabel.text
                    self.dateLabel.transform = CGAffineTransformIdentity
                    self.dateLabel.alpha = 1
                    updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.dateLabel)
        }
    }
    
    func didSelectDayView(dayView: DayView, animationDidFinish: Bool) {
        
            print("\(dayView.date.commonDescription) is selected!")
            selectedDay = dayView
            
            dismissViewControllerAnimated(true, completion: nil)
            
            let selectedDate =  dayView.date.convertedDate()
            
            let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            
            var convertedDate = currentDate?.convertedDate()
            
            let componentsCurrentDate = calendar?.components([.Year,.Month,.Day], fromDate: convertedDate!)
            
            let componentsSelectedDate = calendar?.components([.Year,.Month,.Day], fromDate: selectedDate!)
            
            componentsCurrentDate?.setValue((componentsSelectedDate?.month)!, forComponent: NSCalendarUnit.Month)
            
            componentsCurrentDate?.setValue((componentsSelectedDate?.day)!, forComponent: NSCalendarUnit.Day)
            
            convertedDate = calendar!.dateFromComponents(componentsCurrentDate!)
        
            currentDate = CVDate(date: convertedDate!)
            
            let printFormatter = NSDateFormatter()
            printFormatter.dateFormat = "MMM, d"
            
            title = printFormatter.stringFromDate((convertedDate)!)
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "M"
            let month = formatter.stringFromDate(convertedDate!)
            formatter.dateFormat = "d"
            let day = formatter.stringFromDate(convertedDate!)
            
            if view != nil {
                (swipeView.currentItemView as! DayPreviewView).reloadData(month, day: day)
            }
        
    }
}

extension NSDate {
    func toString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy - HH:mm"
        return dateFormatter.stringFromDate(self)
    }
    
    func getTime() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.stringFromDate(self)
    }
    
    func getDate() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.stringFromDate(self)
    }
    
    func getDateWithString(dateString: String)->NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.dateFromString(dateString)
    }
}