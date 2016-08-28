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
    var selectedStation : NSDictionary!
    var direction : Bool?

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
        let latitude = selectedStation["Latitude"]!.doubleValue
        let longitude = selectedStation["Longitude"]!.doubleValue
        let zoomLevel = 14.0 as float_t;
        let selectedStationName = selectedStation["Station"] as? String
        self.title = selectedStationName
        
        let camera = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom:zoomLevel)
        let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        mapView.myLocationEnabled = true
        view = mapView
        
        var previousStation : NSDictionary?
        
        // 0 up: pick the station before selected station
        if ((direction) != nil) {
            
            let index = stations .indexOf(selectedStation)
            previousStation = stations[(index! - 1)]
            
        } else { // 1 down: pick the station after selected station
            let index = stations .indexOf(selectedStation)
            previousStation = stations[(index! + 1)]
        }

        
        for station in stations {
            
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: (station["Latitude"] as! NSString!).doubleValue, longitude: (station["Longitude"] as! NSString!).doubleValue)
            
            let stationName = station["Station"] as! NSString! as String;
            marker.title = stationName
            marker.iconView = UIImageView.init(image: UIImage.init(named: "station"))
            marker.iconView.layer.cornerRadius = 8.0
            marker.iconView.layer.backgroundColor = UIColor.clearColor().CGColor;
            marker.opacity = 0.5
            marker.map = mapView
            
            if (stationName == selectedStationName) {
                marker.opacity = 1.0
                marker.iconView.layer.backgroundColor = UIColor.greenColor().CGColor;
            } else if (stationName == previousStation!["Station"] as! String) {
//                marker.opacity = 1.0
//                marker.iconView.layer.backgroundColor = UIColor.redColor().CGColor;
            }
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
