//
//  Event.swift
//  PosterApp
//
//  Created by Gladwin Dosunmu on 18/12/2015.
//  Copyright © 2015 Gladwin Dosunmu. All rights reserved.
//

import Foundation
import Parse

class Event {
    // Mark - Public API
    var title: String!
    var date: String!
    var eventImage: UIImage!
    var eventID: String!
    
    init(title: String, date: String, eventID: String, eventImage: UIImage!) {
        
        self.title = title
        self.date = date
        self.eventID = eventID
        self.eventImage = eventImage
    }

}




