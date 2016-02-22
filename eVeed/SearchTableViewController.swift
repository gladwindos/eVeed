//
//  SearchTableViewController.swift
//  PosterApp
//
//  Created by Gladwin Dosunmu on 31/01/2016.
//  Copyright © 2016 Gladwin Dosunmu. All rights reserved.
//

import UIKit
import Parse

class SearchTableViewController: UITableViewController {
    
    var createdEvents: [Event] = []
    
    var activityIndicator = UIActivityIndicatorView()
    
    func loadEvents() {
        
        
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        createdEvents = []
        
        let query = PFQuery(className: "Event")
        
        var newImage: UIImage!
        
        query.whereKey("reviewed", equalTo: true)
        
        query.whereKey("eventDate", greaterThanOrEqualTo: NSDate())
        
        query.orderByAscending("eventDate")
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            
            if error != nil {
                
                print(error)
                
                
            } else if let objects = objects {
                
                for object in objects {
                    
                    let imageFile = object["imageFile"] as! PFFile
                    
                    do {
                        
                        
                        let evImage = try imageFile.getData()
                        
                        newImage = UIImage(data: evImage)
                        
                        
                    } catch {print(error)}
                    
                    
                    // Can't get image from inside block before setting image in collection view cell,
                    
                    
                    //                    let imageFile = object["imageFile"] as! PFFile
                    
                    //                    imageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                    //
                    //                        if error != nil {
                    //
                    //                            print(error)
                    //
                    //                        } else {
                    //
                    //                            if let data = imageData {
                    //
                    //                                newImage = UIImage(data: data)
                    //                                print(newImage)
                    //
                    //                            }
                    //
                    //                        }
                    //
                    //                    })
                    
                    let parseDate = object["eventDate"] as! NSDate
                    
                    let dateFormatter = NSDateFormatter()
                    
                    dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                    
                    dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                    
                    let dateString = dateFormatter.stringFromDate(parseDate)
                    
                    self.createdEvents.append(Event(title: object["title"] as! String, date: dateString, eventID: object.objectId!, eventImage: newImage, university: object["university"] as! String))
                    
                }
                
            }
            
            self.tableView.reloadData()
            
            
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredEvents = [Event]()
    
    func filterContentForSearch(searchText: String, scope: String = "All") {
        filteredEvents = createdEvents.filter { event in
            return (event.title.lowercaseString.containsString(searchText.lowercaseString)) || (event.university.lowercaseString.containsString(searchText.lowercaseString))
            
        }
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.placeholder = "Search Event or University"
        
        loadEvents()
        
        self.searchController.loadViewIfNeeded()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    deinit {
        
        self.searchController.loadViewIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.active && searchController.searchBar.text != "" {
            return filteredEvents.count
        }
        return createdEvents.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("search cell", forIndexPath: indexPath)
        
        let event: Event
        
        if searchController.active && searchController.searchBar.text != "" {
            event = filteredEvents[indexPath.row]
        } else {
            event = createdEvents[indexPath.row]
        }
        
        cell.textLabel?.text = event.title
        cell.textLabel?.font = UIFont.systemFontOfSize(18)
        
        cell.detailTextLabel?.text = event.date
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(12)
        cell.detailTextLabel?.textColor = UIColor.grayColor()

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let infoVC: EventDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Event Details") as! EventDetailsViewController
        infoVC.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        let event: Event
        
        if searchController.active && searchController.searchBar.text != "" {
            event = filteredEvents[indexPath.row]
        } else {
            event = createdEvents[indexPath.row]
        }
        
        let cellEventId = event.eventID
        
        let query = PFQuery(className: "Event")
        
        query.getObjectInBackgroundWithId(cellEventId, block: { (object, error) -> Void in
            
            if error != nil {
                
                print(error)
                
            } else if let event = object {
                
                infoVC.eventId = cellEventId
                
                if let imageFile = event["imageFile"]{
                    
                    imageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                        
                        if error != nil {
                            
                            print(error)
                            
                        } else {
                            
                            if let data = imageData {
                                
                                infoVC.imageHolder = UIImage(data: data)!
                                
                                infoVC.viewDidLoad()
                                
                            }
                            
                        }
                        
                    })
                }
                if (event["title"] != nil) {
                    
                    infoVC.titleHolder = event["title"] as! String
                    
                }
                
                let parseDate = event["eventDate"] as! NSDate
                
                let dateFormatter = NSDateFormatter()
                
                dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                
                dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                
                let dateString = dateFormatter.stringFromDate(parseDate)
                
                if (event["eventDate"] != nil) {
                    
                    infoVC.dateHolder = dateString
                    
                }
                
                if (event["extraInfo"] != nil) {
                    
                    infoVC.extraInfoHolder = event["extraInfo"] as! String
                    
                }
                
                if (event["location"] != nil) {
                    
                    infoVC.locationHolder = event["location"] as! String
                    
                }
                
                if let link = event["ticketLink"] {
                    
                    if link as! String == "" {
                        
                        infoVC.ticketLink.hidden = true
                        
                    } else {
                        
                        infoVC.ticketLinkHolder = event["ticketLink"] as! String
                    }
                    
                }
                
                if (event["userid"] != nil) {
                    
                    let eventUserId = event["userid"] as! String
                    
                    do {
                        
                        let eventUser = try PFQuery.getUserObjectWithId(eventUserId)
                        infoVC.usernameHolder = "Posted by " + eventUser.username!
                        
                    } catch {
                        print(error)
                    }
                    
                }
                
                if let currentUser = PFUser.currentUser() {
                    
                    if currentUser["favourites"].containsObject(cellEventId) {
                        
                        infoVC.isFavourite = true
                        
                    } else {
                        
                        infoVC.isFavourite = false
                    }
                    
                    
                }
                
                self.activityIndicator.stopAnimating()
//                infoVC.viewDidLoad()
            }
        })
        
        self.showViewController(infoVC, sender: self)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchTableViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearch(searchController.searchBar.text!)
    }
}
















