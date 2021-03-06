//
//  User.swift
//  RumeshChandima-cobsccomp182p-024
//
//  Created by Geeth Rangana on 3/1/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import Foundation

struct User {
    var firstname:String
    var lastname:String
    var id : String
    var email:String
    var contactnumber:Int
    var facebooklink:String
    var profilepicUrl:String
    
    init( firstname : String,
          lastname:String,
          id : String,
          email : String,
          contactnumber : Int,
          facebooklink : String,
          profilepicUrl : String){
        
        self.firstname = firstname
        self.lastname = lastname
        self.id = id
        self.email = email
        self.contactnumber = contactnumber
        self.facebooklink = facebooklink
        self.profilepicUrl = profilepicUrl
    }
    
    
    init(data :[String : Any]) {
        self.firstname = data["firstname"] as? String ?? ""
        self.lastname = data["lastname"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.contactnumber = data["contactnumber"] as? Int ?? 0
        self.facebooklink = data["facebooklink"] as? String ?? ""
        self.profilepicUrl = data["profilepicUrl"] as? String ?? ""
    }
    
    static func modelToData(user : User) -> [String : Any] {
        
        let data : [String : Any] = [
            "contactnumber": user.contactnumber,
            "email" : user.email,
            "facebooklink" : user.facebooklink,
            "id" : user.id,
            "lastname": user.lastname,
            "firstname": user.firstname,
            "profilepicUrl" : user.profilepicUrl
        ]
        
        return data
    }
}
