//
//  FavouritesViewController.swift
//  PosterApp
//
//  Created by Gladwin Dosunmu on 31/12/2015.
//  Copyright © 2015 Gladwin Dosunmu. All rights reserved.
//

import UIKit
import Parse

class FavouritesViewController: UIViewController {
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    var userFavourites: [String] = []
    
    // MARK: - IBOulets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func refreshAction(sender: AnyObject) {
        
        viewDidLoad()
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    var createdEvents: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadEVents()
        
    }
    
    var activityIndicator = UIActivityIndicatorView()
    
    func loadEVents() {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
                // Clear Events array
        createdEvents = []
        
        
        if (PFUser.currentUser() == nil) {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let tbVc: UITabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Tab Bar Controller") as! TabBarController
                
                tbVc.viewDidLoad()
                
                self.presentViewController(tbVc, animated: true, completion: nil)
            })
        }
        
        let currentUser = PFUser.currentUser()
        
        userFavourites = (currentUser?.objectForKey("favourites"))! as! [String]
        
        let query = PFQuery(className: "Event")
        
        query.whereKey("objectId", containedIn: userFavourites)
        
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
            
            self.collectionView.reloadData()
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        loadEVents()
    }
    
    
    private struct Storyboard {
        static let CellIdentifier = "Event Cell"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "show fav info" {
            
            if let indexPath = self.collectionView?.indexPathForCell(sender as! UICollectionViewCell) {
                
                let infoVC: EventDetailsViewController = segue.destinationViewController as! EventDetailsViewController
                
                let cellEventId = createdEvents[indexPath.row].eventID
                
                let query = PFQuery(className: "Event")
                
                query.orderByAscending("eventDate")
                
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

extension FavouritesViewController: UICollectionViewDataSource {
    
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

extension FavouritesViewController: UIScrollViewDelegate {
    
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








