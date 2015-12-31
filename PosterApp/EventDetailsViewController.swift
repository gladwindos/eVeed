//
//  EventInfoViewController.swift
//  PosterApp
//
//  Created by Gladwin Dosunmu on 20/12/2015.
//  Copyright © 2015 Gladwin Dosunmu. All rights reserved.
//

import UIKit
import Parse

class EventDetailsViewController: UIViewController {
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var eventTitle: UILabel!
    
    var titleHolder = ""
    
    @IBOutlet var eventDate: UILabel!
    
    var dateHolder = ""
    
    @IBOutlet var eventImage: UIImageView!
    
    var imageHolder: UIImage = UIImage(named: "placeholder")!
    
    @IBOutlet var extraInfo: UITextView!
    
    var extraInfoHolder = ""
    
    @IBOutlet var ticketLink: UIButton!
    
    var ticketLinkHolder = ""
    
    var eventId = ""
    
    @IBAction func ticketLinkAction(sender: UIButton) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ticket link" {
            let wVc: WebViewController = segue.destinationViewController as! WebViewController
            
            wVc.webViewHolder = ticketLinkHolder
            
        }
    }
    
    var userFavourites: [String] = []
    
    
    @IBAction func addToFavourites(sender: AnyObject) {
        
        var AddorRemove = ""
        
        if let user = PFUser.currentUser() {
            
            userFavourites = user.objectForKey("favourites") as! [String]
            
            if userFavourites.contains(eventId) {
                
                user.removeObject(eventId, forKey: "favourites")
                
                AddorRemove = "removed from"
                
            } else {
                
                user.addObject(eventId, forKey: "favourites")
                
                AddorRemove = "added to"
            }
            
            user.saveInBackgroundWithBlock { (success, error) -> Void in
                
                if success {
                    
                    self.displayAlert("\(AddorRemove.capitalizedString) Favourites", message: "This event has been \(AddorRemove) your favourites")
                    
                } else {
                    
                    self.displayAlert("Error", message: "\(error)")
                }
            }
            
        } else {
            
            displayAlert("Sorry", message: "You need to login to add to your favourites")
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        scrollView.contentSize.height = 1250
        
        eventTitle.text = titleHolder
        
        eventDate.text = dateHolder
        
        eventImage.image = imageHolder
        
        extraInfo.text = extraInfoHolder

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
