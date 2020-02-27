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
    var createrName: String
    var id: String
    var eventName: String
    var location : String
    var imageUrl: String
    var description: String
    var time: Timestamp
    var goingCount: Int
}
