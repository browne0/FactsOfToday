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
        
        var label: UILabel? = nil
        
        if view == nil {
            
            view = UIView(frame: self.swipeView.bounds)
            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            label = UILabel(frame: view.bounds)
            label!.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            label!.backgroundColor = UIColor.clearColor()
            label!.textAlignment = .Center
            label!.font = label!.font.fontWithSize(50)
            label!.tag = 1
            view.addSubview(label!)
        } else {
            //get a reference to the label in the recycled view
            label = (view.viewWithTag(1) as! UILabel)
        }
        
        label!.text = items[index].stringValue
        
        return view
    }
    
    func numberOfItemsInSwipeView(swipeView: SwipeView!) -> Int {
        return items.count
    }
    
    func swipeViewItemSize(swipeView: SwipeView!) -> CGSize {
        return self.swipeView.bounds.size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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