//
//  ProfileViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/31/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBAction func logOutAction(sender: AnyObject) {
        
        PFUser.logOutInBackgroundWithBlock { (error) -> Void in
            
            if error == nil {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let tbVc: UITabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Tab Bar Controller") as! TabBarController
                    
                    tbVc.viewWillAppear(true)
                    
                    self.presentViewController(tbVc, animated: true, completion: nil)
                })
            }
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let pUserName = PFUser.currentUser()?["username"] as? String {
            self.userNameLabel.text = "@" + pUserName
        }
        
        if (PFUser.currentUser() == nil) {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let tbVc: UITabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Tab Bar Controller") as! TabBarController
                
                tbVc.viewWillAppear(true)
                
                self.presentViewController(tbVc, animated: true, completion: nil)
            })
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
