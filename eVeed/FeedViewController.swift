//
//  FeedViewController.swift
//  PosterApp
//
//  Created by Gladwin Dosunmu on 18/12/2015.
//  Copyright © 2015 Gladwin Dosunmu. All rights reserved.
//

import UIKit
import Parse 

class FeedViewController: UIViewController {
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - IBOulets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    @IBAction func refreshAction(sender: AnyObject) {
        
        viewDidLoad()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadEvents()
        
    }
    
    var activityIndicator = UIActivityIndicatorView()
    
    var createdEvents: [Event] = []
    
    func loadEvents() {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        createdEvents = []
        
        let query = PFQuery(className: "Event")
        
        var newImage: UIImage!
        
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
                    
                    
                    // Asynchrous call messes up order
                    
                    
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
            
            self.collectionView.reloadData()
            
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {


//        loadEvents()
    }
    
    private struct Storyboard {
        static let CellIdentifier = "Event Cell"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "show info" {
            
            if let indexPath = self.collectionView?.indexPathForCell(sender as! UICollectionViewCell) {
                
                let infoVC: EventDetailsViewController = segue.destinationViewController as! EventDetailsViewController
                
                let cellEventId = createdEvents[indexPath.row].eventID
                
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
                        
                        
                        infoVC.viewDidLoad()
                    }
                })
                
            }
        }
    }
    
}

extension FeedViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return createdEvents.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.CellIdentifier, forIndexPath: indexPath) as! EventCollectionViewCell
        
        cell.event = self.createdEvents[indexPath.item]
        
        return cell
    }
}

extension FeedViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.memory
        
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        
        targetContentOffset.memory = offset
    }
}






















