//
//  AppDelegate.swift
//  PosterApp
//
//  Created by Gladwin Dosunmu on 10/12/2015.
//  Copyright © 2015 Gladwin Dosunmu. All rights reserved.
//

import UIKit
import Parse
import Bolts
import ParseTwitterUtils

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios/guide#local-datastore
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("q1GPaUdqAL52jE7zjQiPb4hbH1UCxGsf4HpcVTIQ",
            clientKey: "8jeg4Hc7KUiv0zS2LfhYhoh0Eld3GbJzr9EIbIJj")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        PFTwitterUtils.initializeWithConsumerKey("NwAjYNiwUD87sY0spw7joQbGB",  consumerSecret:"Lr2AYd1gi6MQG4HT2Dw1jDCDijpOayu82f5Iu7h2x348SIWpsJ")
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

