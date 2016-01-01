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
    
    
    // MARK: - UICollectionViewDataSource
    
    var createdEvents: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Clear events array
        createdEvents = []
        
        let query = PFQuery(className: "Event")
        
        var newImage: UIImage!
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
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
                    // do - catch, temporary fix
                    
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
                    
                    self.createdEvents.append(Event(title: object["title"] as! String, date: "5th of Dec", eventID: object.objectId!, eventImage: newImage))
                    
                }
                
            }
            
            self.collectionView.reloadData()
            
        }
        
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
                        
                        if (event["eventDate"] != nil) {
                            
                            infoVC.dateHolder = "5th of Dec"
                            
                        }
                        
                        if (event["extraInfo"] != nil) {
                            
                            infoVC.extraInfoHolder = event["extraInfo"] as! String
                            
                        }
                        
                        if (event["ticketLink"] != nil) {
                            
                            infoVC.ticketLinkHolder = event["ticketLink"] as! String
                            
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






















