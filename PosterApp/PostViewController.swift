//
//  ViewController.swift
//  PosterApp
//
//  Created by Gladwin Dosunmu on 10/12/2015.
//  Copyright © 2015 Gladwin Dosunmu. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var imageToPost: UIImageView!
    
    var imageHolder: UIImage = UIImage(named: "placeholder")!
    
    @IBOutlet var chooseImageOutlet: UIButton!
    
    @IBAction func chooseImageAction(sender: UIButton) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageToPost.image = image
        
        chooseImageOutlet.setTitle("Change Image", forState: UIControlState.Normal)
    }
    
    @IBOutlet var eventTitle: UITextField!
    
    var titleHolder = ""
    
    @IBOutlet var eventDate: UIDatePicker!
    
    var dateHolder = NSDate()
    
    @IBOutlet var eventTicketLink: UITextField!
    
    var ticketHolder = ""
    
    @IBOutlet var eventExtraInfo: UITextView!
    
    var extraInfoHolder = ""
    
    @IBOutlet weak var eventLocation: UITextView!
    
    var locationHolder = ""
    
    var idHolder = ""
    
    var editingPost = false
    
    @IBAction func postEvent(sender: UIButton) {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        
        
        let post = PFObject(className: "Event")
        
        if editingPost == true {
            
            post.objectId = idHolder
        }

        
        post["title"] = eventTitle.text
        
        post["userid"] = PFUser.currentUser()?.objectId
        
        post["eventDate"] = eventDate.date
        
        post["ticketLink"] = eventTicketLink.text
        
        post["extraInfo"] = eventExtraInfo.text
        
        post["location"] = eventLocation.text
        
        let imageData = UIImageJPEGRepresentation(imageToPost.image!, 0.5)
        
        let imageFile = PFFile(name: "\(eventTitle.text!)_image.png", data: imageData!)
        
        post["imageFile"] = imageFile
        
        post.saveInBackgroundWithBlock { (success, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            
            
            if error == nil {
                
                let alert = UIAlertController(title: "Done", message: "Event has been posted successfully", preferredStyle: UIAlertControllerStyle.Alert)
                
                
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                    
                    //                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        let tbVc: UITabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Tab Bar Controller") as! TabBarController
                        
                        tbVc.viewDidLoad()
                        
                        tbVc.selectedIndex = 0
                        
                        self.presentViewController(tbVc, animated: true, completion: nil)
                    })
                    
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                
                self.displayAlert("Error", message: "Please try again later")
                
            }
            
        }
        
        chooseImageOutlet.setTitle("Choose Image", forState: UIControlState.Normal)
        
        editingPost = false
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scrollView.keyboardDismissMode = .OnDrag
        
        if (PFUser.currentUser() == nil) {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let tbVc: UITabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Tab Bar Controller") as! TabBarController
                
                tbVc.viewDidLoad()
                
                self.presentViewController(tbVc, animated: true, completion: nil)
            })
        }
        
        eventExtraInfo.layer.borderWidth = 1.0
        eventExtraInfo.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        eventLocation.layer.borderWidth = 1.0
        eventLocation.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        scrollView.contentSize.height = 1600
        
        eventTitle.text = titleHolder
        
        eventDate.date = dateHolder
        
        imageToPost.image = imageHolder
        
        eventExtraInfo.text = extraInfoHolder
        
        eventLocation.text = locationHolder
        
        eventTicketLink.text = ticketHolder
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(TextField: UITextField!) -> Bool {
        
        TextField.resignFirstResponder()
        
        return true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

