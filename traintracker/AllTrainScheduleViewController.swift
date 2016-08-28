//
//  AllTrainScheduleViewController.swift
//  traintracker
//
//  Created by Dinesh Gajjar on 27/08/16.
//  Copyright © 2016 Mobiuso. All rights reserved.
//

import UIKit

class AllTrainScheduleViewController: UITableViewController {
    
    var trainsTimeTable : [Dictionary<String, String>] = []
    var uptrainsTimeTable : [Dictionary<String, String>] = []
    var downtrainsTimeTable : [Dictionary<String, String>] = []
    var selectedStation : NSDictionary!
    var stationName: String?
    var direction: String?
    
    var stationsArray: [String] = ["Khopoli", "Lowjee", "Dolavi", "Kelavi", "Palasdari", "Karjat", "Bhivpuri", "Neral", "Shelu", "Vangani", "Badlapur", "Ambernath", "Ulhasnagar", "Vithalwadi", "Kalyan", "Thakurli", "Dombivili", "Kopar", "Diva", "Mumbra", "Kalwa", "Thane", "Mulund", "Nahur", "Bhandup", "Kanjurmarg", "Vikhroli", "Ghatkopar", "Vidhyavihar", "Kurla", "Sion", "Matunga", "Dadar", "Parel", "Currey Road", "Chinchpokli", "Byculla", "Sandhurst Road", "Masjid", "Mumbai CST"]

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let path = NSBundle.mainBundle().pathForResource("upTrains", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let stationlist: [Dictionary<String, String>] = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! [Dictionary<String, String>]
                for station in stationlist {
                    uptrainsTimeTable.append(station)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }

        if let path = NSBundle.mainBundle().pathForResource("downTrains", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let stationlist: [Dictionary<String, String>] = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! [Dictionary<String, String>]
                for station in stationlist {
                    downtrainsTimeTable.append(station)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }

        stationName = selectedStation["Station"] as? String

        self.title = stationName
        
        if (direction == "UP") {
            trainsTimeTable = uptrainsTimeTable
        } else {
            trainsTimeTable = downtrainsTimeTable
        }
        
        // train stop at this station
        trainsTimeTable = trainsTimeTable.filter( { $0[stationName!] != nil } )
        
        // sort trains with the time at which they arrive on the station from 00:00 to 23:59
        trainsTimeTable = trainsTimeTable.sort({ (left, right) -> Bool in
            var lefttime = left[stationName!]!
            var righttime = right[stationName!]!
            
            let leftday: String = lefttime.substringFromIndex(lefttime.startIndex.advancedBy(6))
            let rightday: String = righttime.substringFromIndex(righttime.startIndex.advancedBy(6))
            
            lefttime = lefttime.stringByReplacingOccurrencesOfString("12", withString: "00")
            righttime = righttime.stringByReplacingOccurrencesOfString("12", withString: "00")

            return (leftday == rightday) ? (lefttime < righttime) : (leftday < rightday)
        })
        
        // filter trains after this time
        let time: String = getFormattedDate(NSDate(), format: "hh:mm a").lowercaseString
        
        var selectedTrainsTimeTable = trainsTimeTable.filter({ (element) -> Bool in
            var lefttime = time
            var righttime = element[stationName!]!
            
            let leftday: String = lefttime.substringFromIndex(lefttime.startIndex.advancedBy(6))
            let rightday: String = righttime.substringFromIndex(righttime.startIndex.advancedBy(6))
            
            lefttime = lefttime.stringByReplacingOccurrencesOfString("12", withString: "00")
            righttime = righttime.stringByReplacingOccurrencesOfString("12", withString: "00")
            
            return (leftday == rightday) ? (lefttime < righttime) : (leftday < rightday)
        })
        
        selectedTrainsTimeTable.appendContentsOf(trainsTimeTable)
        
        trainsTimeTable.removeAll(keepCapacity: false)
        
        // pick 3 trains
        for i in 0...2 {
            if (i < selectedTrainsTimeTable.count) {
                trainsTimeTable.append(selectedTrainsTimeTable[i]);
            }
        }
    }
    
    func getFormattedDate(date:NSDate, format:String) -> String {
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        let todayString:String = dateFormatter.stringFromDate(date)
        return todayString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else {
            return trainsTimeTable.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StationCellIdentifier", forIndexPath: indexPath)
        
        if (indexPath.section == 0) {
            cell.textLabel?.text = "View upcoming trains on Map"
            cell.detailTextLabel!.text = ""
        } else {
            let object = self.trainsTimeTable[indexPath.row]
            self.configureCell(cell, withObject: object)
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {

            if let context = UIApplication.sharedApplication().keyWindow?.rootViewController {
                let vc: UpcomingTrainsMapViewController = context.storyboard?.instantiateViewControllerWithIdentifier("UpcomingTrainsMapViewController") as! UpcomingTrainsMapViewController
                vc.selectedStation = selectedStation
                vc.navigationItem.leftItemsSupplementBackButton = true
                
                (context as? UINavigationController)?.pushViewController(vc, animated: true)
            }
        } else {
            if let context = UIApplication.sharedApplication().keyWindow?.rootViewController {
                let vc: SingleTrainScheduleViewController = context.storyboard?.instantiateViewControllerWithIdentifier("SingleTrainScheduleViewController") as! SingleTrainScheduleViewController
                vc.navigationItem.leftItemsSupplementBackButton = true
                vc.traindata = trainsTimeTable[indexPath.row]
                (context as? UINavigationController)?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    func configureCell(cell: UITableViewCell, withObject object: NSDictionary) {
        var startLocation: String?
        var endLocation: String?
        
        let localStationArr = (direction == "UP") ? stationsArray : stationsArray.reverse()
        
        for station in localStationArr {
            if (object[station] != nil) {
                if (startLocation == nil) {
                    startLocation = station
                }
                
                endLocation = station
            }
        }
        
        cell.textLabel!.text = "\(object[stationName!] as! String!)"
        cell.detailTextLabel!.text = "\(startLocation!) - \(endLocation!)"
    }


}
