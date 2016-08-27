//
//  SingleTrainScheduleViewController.swift
//  traintracker
//
//  Created by Manish Raje on 8/27/16.
//  Copyright © 2016 Mobiuso. All rights reserved.
//

import UIKit

class SingleTrainScheduleViewController: UITableViewController {
    var trainTimeTable: Array< Dictionary<String, String> > = Array< Dictionary<String, String> >()

    var stationsArray: [String] = ["Khopoli", "Lowjee", "Dolavi", "Kelavi", "Palasdari", "Karjat", "Bhivpuri", "Neral", "Shelu", "Vangani", "Badlapur", "Ambernath", "Ulhasnagar", "Vithalwadi", "Kalyan", "Thakurli", "Dombivili", "Kopar", "Diva", "Mumbra", "Kalwa", "Thane", "Mulund", "Nahur", "Bhandup", "Kanjurmarg", "Vikhroli", "Ghatkopar", "Vidhyavihar", "Kurla", "Sion", "Matunga", "Dadar", "Parel", "Currey Road", "Chinchpokli", "Byculla", "Sandhurst Road", "Masjid", "Mumbai CST"]

    var traindata : Dictionary<String, String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for station in stationsArray {
            if let timing = traindata?[station] {
                trainTimeTable.append(["name" : station, "time": timing])
            }
        }

        // Do any additional setup after loading the view.
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainTimeTable.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SingleTrainStationCellIdentifier", forIndexPath: indexPath)
        
        let object = self.trainTimeTable[indexPath.row]
        self.configureCell(cell, withObject: object)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, withObject object: NSDictionary) {
        cell.textLabel!.text = "\(object["name"] as! String!)"
        cell.detailTextLabel!.text = "\(object["time"] as! String!)"
    }

}
