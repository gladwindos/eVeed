//
//  SignUpViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/30/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var usernameField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func signUpAction(sender: AnyObject) {
        
        let username = self.usernameField.text
        let password = self.passwordField.text
        let email = self.emailField.text
        let finalEmail = email?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        // Validate text fields
        if username?.characters.count < 5 {
            
            displayAlert("invalid", message: "Username must be greater than 5 characters")
            
        } else if password?.characters.count < 8 {
            
            displayAlert("Invalid", message: "Password must be greater than 8 characters")
            
        } else if email?.characters.count < 8 {
            
            displayAlert("invalid", message: "Password must be greater than 8 characters")
            
        } else {
            
            // Run a spinner to show task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            let newUser = PFUser()
            
            newUser.username = username
            newUser.password = password
            newUser.email = finalEmail
            newUser["favourites"] = []
            
            // Sign up user asynchronously
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                //Stop spinner
                spinner.stopAnimating()
                
                if ((error) != nil) {
                    
                    self.displayAlert("Error", message: "\(error)")
                    
                } else {
                    
                    let alert = UIAlertController(title: "Success", message: "Signed Up", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                        }))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let tbVc: TabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Tab Bar Controller") as! TabBarController
                        
                        tbVc.viewWillAppear(true)
                        
                        
                        self.presentViewController(tbVc, animated: true, completion: nil)
                        
                    })
                    
                }
            })
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(TextField: UITextField!) -> Bool {
        
        TextField.resignFirstResponder()
        
        return true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
