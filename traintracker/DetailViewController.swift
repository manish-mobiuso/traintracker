//
//  DetailViewController.swift
//  traintracker
//
//  Created by Manish Raje on 8/27/16.
//  Copyright © 2016 Mobiuso. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

//    @IBOutlet weak var tableView: UITableView!

    var stations : [NSDictionary] = []

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
    }

    override func viewDidLoad() {
        
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
        
        super.viewDidLoad()
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        //        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "alltrainsTimeTable" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = self.stations[indexPath.row]
                let controller = segue.destinationViewController as! AllTrainScheduleViewController
                controller.selectedTrain = object

                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StationCell", forIndexPath: indexPath)
        let object = self.stations[indexPath.row]
        self.configureCell(cell, withObject: object["Station"] as! NSString)
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func configureCell(cell: UITableViewCell, withObject object: NSString) {
        cell.textLabel!.text = object as String
    }

}

