//
//  UpcomingTrainsMapViewController.swift
//  traintracker
//
//  Created by Dinesh Gajjar on 27/08/16.
//  Copyright © 2016 Mobiuso. All rights reserved.
//

import UIKit
import GoogleMaps

class UpcomingTrainsMapViewController: UIViewController {
    var stations : [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        if let path = NSBundle.mainBundle().pathForResource("stationlist", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let stationlist: [NSDictionary] = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! [NSDictionary]
                for station: NSDictionary in stationlist {
                    stations.append(station)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }

        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.cameraWithLatitude(19, longitude: 72.9, zoom: 11.0)
        let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        mapView.myLocationEnabled = true
        view = mapView
        
        for station in stations {
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: (station["Latitude"] as! NSString!).doubleValue, longitude: (station["Longitude"] as! NSString!).doubleValue)
            marker.title = station["Station"] as! NSString! as String
            marker.icon = UIImage.init(named: "station")
            marker.opacity = 0.6
            marker.map = mapView
        }
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
