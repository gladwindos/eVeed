//
//  EventInfoViewController.swift
//  PosterApp
//
//  Created by Gladwin Dosunmu on 20/12/2015.
//  Copyright © 2015 Gladwin Dosunmu. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var eventTitle: UILabel!
    
    var titleHolder = ""
    
    @IBOutlet var eventDate: UILabel!
    
    var dateHolder = ""
    
    @IBOutlet var eventImage: UIImageView!
    
    var imageHolder: UIImage = UIImage(named: "placeholder")!
    
    @IBOutlet var extraInfo: UITextView!
    
    var extraInfoHolder = ""
    
    @IBOutlet var ticketLink: UIButton!
    
    var ticketLinkHolder = ""
    
    @IBAction func ticketLinkAction(sender: UIButton) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ticket link" {
            let wVc: WebViewController = segue.destinationViewController as! WebViewController
            
            wVc.webViewHolder = ticketLinkHolder
            
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        scrollView.contentSize.height = 1250
        
        eventTitle.text = titleHolder
        
        eventDate.text = dateHolder
        
        eventImage.image = imageHolder
        
        extraInfo.text = extraInfoHolder

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
