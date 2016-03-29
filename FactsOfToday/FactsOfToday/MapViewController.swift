//
//  MapViewController.swift
//  FactsOfToday
//
//  Created by Evan on 3/26/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
	
	@IBOutlet weak var mapView: MKMapView!
	var locationManager: CLLocationManager!
	var articleTitle: String!
	var coordinates: CLLocationCoordinate2D!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		locationManager = CLLocationManager()
		locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
		locationManager.requestWhenInUseAuthorization()
		
		mapView.setRegion(MKCoordinateRegionMake(coordinates, MKCoordinateSpanMake(14.5, 14.5)), animated: false)
		
		
		let annotation = MKPointAnnotation()
		annotation.coordinate = coordinates
		annotation.title = articleTitle
		mapView.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let nb = self.navigationController?.navigationBar
        let colorScheme = ColorScheme.getInstance()
        nb?.barTintColor = colorScheme.barTintColor
        nb?.titleTextAttributes = [NSForegroundColorAttributeName : colorScheme.titleColor]
        nb?.tintColor = colorScheme.tintColor
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

	@IBAction func didPressDone(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
}
