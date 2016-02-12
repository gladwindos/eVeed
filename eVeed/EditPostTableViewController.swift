//
//  EditPostTableViewController.swift
//  PosterApp
//
//  Created by Gladwin Dosunmu on 20/01/2016.
//  Copyright © 2016 Gladwin Dosunmu. All rights reserved.
//

import UIKit
import Parse

class EditPostTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadEvents()
        

    }
    
    
    var createdEvents: [Event] = []
    
    var activityIndicator = UIActivityIndicatorView()
    
    func loadEvents() {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let currentUser = PFUser.currentUser()
        
        createdEvents = []
        
        let query = PFQuery(className: "Event")
        
        query.whereKey("userid", equalTo: (currentUser?.objectId)!)
        
        query.orderByAscending("eventDate")
        
        var newImage: UIImage!
        
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
        return createdEvents.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("post to edit", forIndexPath: indexPath)

        cell.textLabel?.text = createdEvents[indexPath.row].title
        
        cell.accessoryType = .DisclosureIndicator

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedEvent = createdEvents[indexPath.row]
        
        let pVc: PostViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Add Post") as! PostViewController
        
        let query = PFQuery(className: "Event")
        
        query.getObjectInBackgroundWithId(selectedEvent.eventID) { (object, error) -> Void in
            
            pVc.editingPost = true
            
            pVc.titleHolder = object!["title"] as! String
            
            pVc.finalDate = object!["eventDate"] as! NSDate
            
            pVc.ticketHolder = object!["ticketLink"] as! String
            
            pVc.extraInfoHolder = object!["extraInfo"] as! String
            
            pVc.locationHolder = object!["location"] as! String
            
            pVc.idHolder = (object?.objectId)!
            
            pVc.universityTextFieldHolder = object!["university"] as! String
            
//            pVc.post = object!
            
            if let imageFile = object!["imageFile"]{
                
                imageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                    
                    if error != nil {
                        
                        print(error)
                        
                    } else {
                        
                        if let data = imageData {
                            
                            pVc.imageHolder = UIImage(data: data)!
                            
                            pVc.viewDidLoad()
                            
                        }
                        
                    }
                    
                })
            }
            
            pVc.viewDidLoad()
        }
        
        
        self.showViewController(pVc, sender: self)

        
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
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
