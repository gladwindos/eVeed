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
    
    
    //            dispatch_async(dispatch_get_main_queue(), { () -> Void in
    //
    //                let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
    //                self.presentViewController(viewController, animated: true, completion: nil)
    //            })

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

    }
    
    override func viewWillAppear(animated: Bool) {
        
        let vc1: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Feed Nav") as! UINavigationController
        
        var vc2 = UIViewController()
        
        if (PFUser.currentUser() == nil) {
            
            vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            
        } else {
            
            vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Profile")
        }
        
        setViewControllers([vc1, vc2], animated: true)
        
        print(viewControllers)
        
//        // Temp fix, finish properly later!!!
//        
//        var vc3 = UIViewController()
//        
//        viewControllers?.removeAtIndex(0)
//        viewControllers?.removeAtIndex(0)
//        
//        if (PFUser.currentUser() == nil) {
//            
//            vc3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
//            
//            viewControllers?.append(vc3)
//            
//        } else {
//            
//            vc3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Profile")
//            
//            viewControllers?.append(vc3)
//        }
//        
//        print(viewControllers)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
