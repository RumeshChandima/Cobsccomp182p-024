//
//  EventDC.swift
//  RumeshChandima-cobsccomp182p-024
//
//  Created by Geeth Rangana on 2/26/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct EventDC {
    
   // var createrProPic: String
    var id: String
    var title: String
    var location : String
    var imageUrl: String
    var description: String
    var time: Timestamp
    var goingCount = [String]()
    var publisherId : String
    var publisher: String

    
    init(
        title:String,
        id : String,
        description : String,
        location :String,
        publisher : String,
        imageUrl: String,
        time : Timestamp,
        publisherId : String,
        goingCount : Array<String>) {
        
        
        self.title = title
        self.id = id
        self.description = description
        self.imageUrl = imageUrl
        self.publisher = publisher
        self.publisherId = publisherId
        self.location = location
        self.time = time
        self.goingCount = goingCount
    }
    
    init(data :[String : Any]) {
        self.title = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.description = data["discription"] as? String ?? ""
        self.location = data["location"] as? String ?? ""
        self.publisher = data["publisher"] as? String ?? ""
        self.imageUrl = data["eventimageUrl"] as? String ?? ""
        self.time = data["timeStamp"] as? Timestamp ?? Timestamp()
        self.publisherId = data["publisherId"] as? String ?? ""
        self.goingCount = (data["participating"] as? Array ?? nil) ?? [""]
    }
    
    static func modelToData(event : EventDC) -> [String:Any]{// set the event data to dictionaty
        let data : [String : Any] = [
            "description" : event.description,
            "id" : event.id,
            "imageUrl" : event.imageUrl,
            "location": event.location,
            "name": event.title,
            "publisher": event.publisher,
            "publisherId": event.publisherId,
            "time": event.time,
            "goingCount": event.goingCount
        ]
        return data
    }
}

