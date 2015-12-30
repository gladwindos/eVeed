//
//  EventCollectionViewCell.swift
//  PosterApp
//
//  Created by Gladwin Dosunmu on 18/12/2015.
//  Copyright © 2015 Gladwin Dosunmu. All rights reserved.
//

import UIKit
import Parse

class EventCollectionViewCell: UICollectionViewCell {
    
    // Mark: - Public API
    
    var event: Event! {
        didSet {
            updateUI()
        }
    }
    
    // Mark: - Private 
    
    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var eventdate: UILabel!
    
    @IBOutlet weak var eventImage: UIImageView!
    
    
    
    private func updateUI() {
        eventTitle.text! = event.title
        eventdate.text! = event.date
        eventImage.image! = event.eventImage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
}
