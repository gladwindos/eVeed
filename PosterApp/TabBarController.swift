//
//  TabBarController.swift
//  PosterApp
//
//  Created by Gladwin Dosunmu on 29/12/2015.
//  Copyright © 2015 Gladwin Dosunmu. All rights reserved.
//

import UIKit
import Parse

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setNewViewControllers()

    }
    
    // Function to set new view controllers
    
    func setNewViewControllers() {
        
        let vc1: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Feed Nav") as! UINavigationController
        
        vc1.tabBarItem.image = UIImage(named: "Activity_Feed-50")
        
        var vc2 = UIViewController()
        
        if (PFUser.currentUser() == nil) {
            
            vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            
        } else {
            
            vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Profile Nav") as! UINavigationController
        }
        
        vc2.tabBarItem.image = UIImage(named: "User_Male-50")
        
        let vc3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Search Nav") as! UINavigationController
        
        vc3.tabBarItem.image = UIImage(named: "Search-50")
        
        setViewControllers([vc1, vc2, vc3], animated: true)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
