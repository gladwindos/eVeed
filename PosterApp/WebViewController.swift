//
//  WebViewController.swift
//  PosterApp
//
//  Created by Gladwin Dosunmu on 21/12/2015.
//  Copyright © 2015 Gladwin Dosunmu. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet var linkWebView: UIWebView!
    
    var webViewHolder = "www.twitter.com"
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let url = NSURL(string: webViewHolder)
        
        let request = NSURLRequest(URL: url!)
        
        linkWebView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
