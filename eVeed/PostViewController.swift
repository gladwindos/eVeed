//
//  ViewController.swift
//  PosterApp
//
//  Created by Gladwin Dosunmu on 10/12/2015.
//  Copyright © 2015 Gladwin Dosunmu. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
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
    
    @IBOutlet weak var addEventOutlet: UIButton!
    
    
    @IBOutlet weak var deleteEventOutlet: UIButton!
    
    @IBAction func deleteAction(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Delete!", message: "Are you sure you want to delete this event?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
            
            let query = PFQuery(className: "Event")
            
            query.getObjectInBackgroundWithId(self.idHolder, block: { (object, error) -> Void in
                if error == nil {
                    
                    object?.deleteInBackgroundWithBlock({ (success, error) -> Void in
                        if error == nil {
                            
                            let user = PFUser.currentUser()
                            
                            user!.removeObject(self.idHolder, forKey: "favourites")
                            
                            user?.saveInBackground()
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                let tbVc: UITabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Tab Bar Controller") as! TabBarController
                                
                                tbVc.viewDidLoad()
                                
                                tbVc.selectedIndex = 1
                                
                                self.presentViewController(tbVc, animated: true, completion: nil)
                            })
                            
                        }
                    })
                }
            })
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        
        
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var imageToPost: UIImageView!
    
    var imageHolder: UIImage = UIImage(named: "eVeed_logo_white")!
    
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
    
    // University picker view
    
    @IBOutlet weak var universityTextField: UITextField!
    
    var universityTextFieldHolder = "University?"
    
    let universityOptions = ["Hertfordshire", "Other"]
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return universityOptions.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return universityOptions[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        universityTextField.text = universityOptions[row]
    }
    
    func donePicker() {
        
        if universityTextField.isFirstResponder() && universityTextField.text == "University?" {
            
            universityTextField.text = universityOptions[0]
        }
        
        self.view.endEditing(true)
    }
    
    
    @IBOutlet var eventTitle: UITextField!
    
    var titleHolder = ""
    
    // Date
    
    @IBOutlet weak var dateText: UITextField!
    
    var finalDate = NSDate()
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .DateAndTime
        
        dateText.inputView = datePicker
        
        datePicker.addTarget(self, action: "datePickerChanged:", forControlEvents: .ValueChanged)
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        
        finalDate = sender.date
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .LongStyle
        formatter.timeStyle = .ShortStyle
        dateText.text = formatter.stringFromDate(sender.date)
    }
    
    
    
    
    @IBOutlet var eventTicketLink: UITextField!
    
    var ticketHolder = ""
    
    @IBOutlet var eventExtraInfo: UITextView!
    
    var extraInfoHolder = "e.g. contact info, age restrictions, ect..."
    
    @IBOutlet weak var eventLocation: UITextView!
    
    var locationHolder = ""
    
    var idHolder = ""
    
    var editingPost = false
    
    @IBAction func postEvent(sender: UIButton) {
        
        if ((eventTitle.text?.isEmpty) == true) {
            
            displayAlert("Error", message: "Please enter a title")
            
        } else if eventTitle.text?.characters.count > 50 {
            
            displayAlert("Error", message: "Title is too long")
            
        }else if eventLocation.text.isEmpty == true {
            
            displayAlert("Error", message: "Please enter a location")
            
        } else {
            
            activityIndicator.startAnimating()
            
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            
            
            let post = PFObject(className: "Event")
            
            if editingPost == true {
                
                post.objectId = idHolder
            }
            
            
            post["title"] = eventTitle.text
            
            post["userid"] = PFUser.currentUser()?.objectId
            
            post["eventDate"] = finalDate
            
            post["ticketLink"] = eventTicketLink.text
            
            post["extraInfo"] = eventExtraInfo.text
            
            post["location"] = eventLocation.text
            
            if universityTextField.text == "University?" {
                universityTextField.text = "Other"
            }
            
            post["university"] = universityTextField.text
            
            let imageData = UIImageJPEGRepresentation(imageToPost.image!, 0.5)
            
            let imageFile = PFFile(name: "eveed_event.png", data: imageData!)
            
            post["imageFile"] = imageFile
            
            post.saveInBackgroundWithBlock { (success, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                
                
                if error == nil {
                    
                    let alert = UIAlertController(title: "eVeed", message: "Your event has been posted successfully", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    
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
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        
        if editingPost == false {
            
            deleteEventOutlet.hidden = true
            
            addEventOutlet.setTitle("Add Event", forState: .Normal)
            
        } else {
            
            deleteEventOutlet.hidden = false
            
            addEventOutlet.setTitle("Update Event", forState: .Normal)
        }
        
        self.dateText.delegate = self
        
        eventTitle.delegate = self
        eventTicketLink.delegate = self
        
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
        
//        scrollView.contentSize.height = 1700
        
        eventTitle.text = titleHolder
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .LongStyle
        formatter.timeStyle = .ShortStyle
        dateText.text = formatter.stringFromDate(finalDate)
        
        imageToPost.image = imageHolder
        
        eventExtraInfo.text = extraInfoHolder
        
        eventLocation.text = locationHolder
        
        eventTicketLink.text = ticketHolder
        
        universityTextField.text = universityTextFieldHolder
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        universityTextField.inputView = pickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker")
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        universityTextField.inputAccessoryView = toolBar
        dateText.inputAccessoryView = toolBar
        eventTitle.inputAccessoryView = toolBar
        eventTicketLink.inputAccessoryView = toolBar
        eventLocation.inputAccessoryView = toolBar
        eventExtraInfo.inputAccessoryView = toolBar
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(TextField: UITextField) -> Bool {
        
        TextField.resignFirstResponder()
        
        return true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

