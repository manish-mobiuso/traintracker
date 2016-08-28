//
//  MasterViewController.swift
//  traintracker
//
//  Created by Manish Raje on 8/27/16.
//  Copyright © 2016 Mobiuso. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var userOptions : [NSString] = []
    
    override func viewDidLoad() {
        userOptions.append("Search by Station")
        userOptions.append("Station near Me")

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.navigationItem.leftBarButtonItem = self.editButtonItem()

//        insertNewObject(nil, option: "Station near Me")
        
//        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewObject(_:)))
//        self.navigationItem.rightBarButtonItem = addButton
//        if let split = self.splitViewController {
//            let controllers = split.viewControllers
//            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
//        }
    }

    override func viewWillAppear(animated: Bool) {
//        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//            let object = self.userOptions[indexPath.row]
//                let controller = segue.destinationViewController as! DetailViewController
//                controller.detailItem = object
////                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
//        }
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            if let context = UIApplication.sharedApplication().keyWindow?.rootViewController {
                let vc: DetailViewController = context.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
                vc.navigationItem.leftItemsSupplementBackButton = true
                
                (context as? UINavigationController)?.pushViewController(vc, animated: true)
            }
            break
        case 1:
            var stations : [NSDictionary] = []
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

            if let context = UIApplication.sharedApplication().keyWindow?.rootViewController {
                let vc: AllTrainScheduleViewController = context.storyboard?.instantiateViewControllerWithIdentifier("AllTrainScheduleViewController") as! AllTrainScheduleViewController
                vc.selectedStation = stations[4] // Chinchpokali
                vc.direction = "UP"
                vc.navigationItem.leftItemsSupplementBackButton = true
                
                (context as? UINavigationController)?.pushViewController(vc, animated: true)
            }
            break
        default:
            break
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userOptions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let object = self.userOptions[indexPath.row]
        self.configureCell(cell, withObject: object)
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

