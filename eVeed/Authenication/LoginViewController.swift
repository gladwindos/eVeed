//
//  LoginViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/28/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse
import ParseTwitterUtils
import ParseUI

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
        
    var activityIndicator = UIActivityIndicatorView()
    
    @IBAction func loginAction(sender: AnyObject) {
        
        let username = self.usernameField.text?.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "")
        let password = self.passwordField.text
        
        
        
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        PFUser.logInWithUsernameInBackground(username!, password: password!) { (user, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if ((user) != nil) {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        let tbVc: UITabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Tab Bar Controller") as! TabBarController
                        
                        tbVc.viewDidLoad()
                        
                        tbVc.selectedIndex = 1
                        
                        self.presentViewController(tbVc, animated: true, completion: nil)
                    })
                
                self.usernameField.text = ""
                
                self.passwordField.text = ""

            } else {
                
                let alert = UIAlertController(title: "Error", message: "\(error!.userInfo["error"]!)", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func twitterLoginAction(sender: AnyObject) {
        
        activityIndicator.startAnimating()
        
        PFTwitterUtils.logInWithBlock { (user: PFUser?, error: NSError?) -> Void in
            
            self.activityIndicator.stopAnimating()
            
            if let user = user {
                if user.isNew {
                    
                    user.username = PFTwitterUtils.twitter()?.screenName
                    
                    user.saveInBackground()
                    
                    user["favourites"] = []
                    
                } else {
                    
                }
                
                let alert = UIAlertController(title: "eVeed", message: "You have logged in as \(user.username!)", preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        let tbVc: UITabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Tab Bar Controller") as! TabBarController
                        
                        tbVc.viewDidLoad()
                        
                        tbVc.selectedIndex = 1
                        
                        self.presentViewController(tbVc, animated: true, completion: nil)
                    })
                    
                    
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                                
            } else {
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        usernameField.delegate = self
        
        passwordField.delegate = self
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToLogInScreen(segue:UIStoryboardSegue) {
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(TextField: UITextField) -> Bool {
        
        TextField.resignFirstResponder()
        
        return true
        
    }

}
