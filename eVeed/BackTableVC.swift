//
//  BackTableVC.swift
//  eVeed
//
//  Created by Gladwin Dosunmu on 26/02/2016.
//  Copyright © 2016 Gladwin Dosunmu. All rights reserved.
//

import Foundation
import Parse

class BackTableVC: UITableViewController {
    
    var universities = [String]()
    
    override func viewDidLoad() {
        universities = ["All", "Hertfordshire", "Bedfordshire", "Northampton", "Wolverhampton", "Other"]
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universities.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = universities[indexPath.row]
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "filterUni" {
            
            let indexpath: NSIndexPath = self.tableView.indexPathForSelectedRow!
            
            let feedNavVC = segue.destinationViewController as! FeedNavigationController
            
            let feedVC = feedNavVC.viewControllers.first as! FeedViewController
            
            feedVC.currentUni = universities[indexpath.row]
            
   
        }
    }
    
}