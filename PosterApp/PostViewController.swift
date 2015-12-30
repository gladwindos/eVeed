//
//  ViewController.swift
//  PosterApp
//
//  Created by Gladwin Dosunmu on 10/12/2015.
//  Copyright © 2015 Gladwin Dosunmu. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerDataSource = ["Herts", "Other"]
    
    var eventUniPicked = 1
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row == 0 {
            
            eventUniPicked = 0
            
        } else if row == 1 {
            
            eventUniPicked = 1
            
        }
        
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
    
    @IBOutlet var eventDate: UIDatePicker!
    
    @IBOutlet var eventTicketLink: UITextField!
    
    @IBOutlet var eventExtraInfo: UITextView!
    
    @IBOutlet var eventUni: UIPickerView!
    
    @IBAction func postEvent(sender: UIButton) {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        
        
        // transforming NSDate to Time
        
        
        let post = PFObject(className: "Event")
        
        post["title"] = eventTitle.text
        
        post["userid"] = "12345" //Change to current user later
        
        post["eventDate"] = eventDate.date
        
        post["ticketLink"] = eventTicketLink.text
        
        post["extraInfo"] = eventExtraInfo.text
        
        post["eventUni"] = eventUniPicked
        
        let imageData = UIImageJPEGRepresentation(imageToPost.image!, 0.5)
        
        let imageFile = PFFile(name: "\(eventTitle.text!)_image.png", data: imageData!)
        
        post["imageFile"] = imageFile
        
        post.saveInBackgroundWithBlock { (success, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil {
                
                self.displayAlert("Done", message: "Event has been posted successfully")
                
                self.imageToPost.image = UIImage(named: "placeholder.png")
                
                self.eventTitle.text = ""
                
                self.eventTicketLink.text = ""
                
                self.eventExtraInfo.text = "" // Change to origonal later
                
            } else {
                
                self.displayAlert("Error", message: "Please try again later")
                
            }
            
        }
        
        chooseImageOutlet.setTitle("Choose Image", forState: UIControlState.Normal)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scrollView.contentSize.height = 1600
        
        self.eventUni.dataSource = self
        self.eventUni.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

