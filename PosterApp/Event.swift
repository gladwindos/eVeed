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
    
    //Mark: - Private
    
//    static func createEvents() -> [Event] {
//        
//        return [
//            Event(title: "Law of Attraction", date: "6th of dec", eventID: "1234", eventImage: UIImage(named: "LOA")!),
//            Event(title: "Set It Off", date: "7th of Dec", eventID: "4321", eventImage: UIImage(named: "Set_it_off")!),
//            Event(title: "Lights Off", date: "8th of Dec", eventID: "2134", eventImage: UIImage(named: "Lights_off")!)
//        ]
//        
//  }
}




