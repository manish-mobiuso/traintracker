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
    var movingTrainDetails : [NSDictionary] = []
    var selectedStation : NSDictionary!
    var direction : String?
    var currentPosition : Int?
    var mapView : GMSMapView?
    var marker : GMSMarker?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        
        loadTrainStationList()
        
        loadTrainPositions()


        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let latitude = selectedStation["Latitude"]!.doubleValue
        let longitude = selectedStation["Longitude"]!.doubleValue
        let zoomLevel = 14.0 as float_t;
        let selectedStationName = selectedStation["Station"] as? String
        self.title = selectedStationName
        
        let camera = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom:zoomLevel)
        mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        mapView!.myLocationEnabled = true
        view = mapView
        
        var previousStation : NSDictionary?
        
        // 0 up: pick the station before selected station (towards CST)
        if ((direction) == "UP") {
            
            let index = stations .indexOf(selectedStation)
            previousStation = stations[(index! - 1)]
            
        } else { // 1 down: pick the station after selected station (Towards Thane)
            let index = stations .indexOf(selectedStation)
            previousStation = stations[(index! + 1)]
        }
        
        /*for station in stations {
            
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
        }*/
        
        let geoFenceCircle = GMSCircle.init() as GMSCircle
        geoFenceCircle.radius = 150; // Meters
        let stationCoordinate = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude) as CLLocationCoordinate2D
        geoFenceCircle.position = stationCoordinate; // Some CLLocationCoordinate2D position
        geoFenceCircle.fillColor = UIColor.init(white: 0.7, alpha: 0.5)
        geoFenceCircle.strokeWidth = 2;
        geoFenceCircle.strokeColor = UIColor.orangeColor();
        geoFenceCircle.map = mapView;
        
        
        marker = GMSMarker()
        marker!.iconView = UIImageView.init(image: UIImage.init(named: "station"))
        marker!.iconView.layer.cornerRadius = 8.0
        marker!.iconView.layer.backgroundColor = UIColor.clearColor().CGColor;
        marker!.opacity = 0.5
        marker!.map = mapView

        currentPosition = 0
        update()
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "update", userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func loadTrainStationList () {
    
        // loading station list
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
    }
    
    func loadTrainPositions() {
        var fileName = "CurryRoad_To_Chinchpokli_UpTrain"
        
        if (direction == "DOWN") {
            fileName = "Byculla_To_ChinchPokli_DownTrain"
        }
        
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let trainPositionList: [Dictionary<String, String>] = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! [Dictionary<String, String>]
                for trainPosition in trainPositionList {
                    movingTrainDetails.append(trainPosition)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        print("loaded movingTrainDetails")
    }
    
    func update() {
        if (movingTrainDetails.count > currentPosition) {
            updateTrainPosition(movingTrainDetails[self.currentPosition!] as! Dictionary<String, String>, mapView: self.mapView!)
            currentPosition = currentPosition! + 1
        }
    }
    
    func updateTrainPosition(trainPosition:Dictionary<String, String>, mapView: GMSMapView) {
        // Creates a marker in the center of the map.
//        marker = GMSMarker()
        marker!.position = CLLocationCoordinate2D(latitude: (trainPosition["Latitude"] as NSString!).doubleValue, longitude: (trainPosition["Longitude"] as NSString!).doubleValue)
        
        let stationName = trainPosition["TrainId"] as NSString! as String;
        marker!.title = stationName
//        marker!.iconView = UIImageView.init(image: UIImage.init(named: "station"))
//        marker!.iconView.layer.cornerRadius = 8.0
//        marker!.iconView.layer.backgroundColor = UIColor.clearColor().CGColor;
//        marker!.opacity = 0.5
//        marker!.map = mapView
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
