//
//  ProfileController.swift
//  RumeshChandima-cobsccomp182p-024
//
//  Created by Geeth Rangana on 2/24/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore
import SwiftyJSON
import Kingfisher

class ProfileController: UIViewController {
    
    let backgroundImageView = UIImageView()
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var txtFbUrl: UITextField!
    @IBOutlet weak var imgProPic: UIImageView!
    
    var UID: String?
    var LIKEHIT: String?
    
    var db : Firestore!
    var loggedUserId : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ViewUserDetails()
        
        db = Firestore.firestore()
        loggedUserId = UserDefaults.standard.string(forKey: UserDefaultsId.userIdUserdefault)
        getData()
    }
    
    func getData(){
        
        let docRef = db.collection("Users").document(loggedUserId)
        
        docRef.getDocument { (snap, error) in
            guard let data = snap?.data() else{return}
            
            let user = User.init(data: data)
            
            self.setDataToView(user: user)//set the data
        }
        
    }
    
    func setDataToView(user : User) {
        
        txtFirstName.text = user.firstname
        txtLastName.text = user.lastname
        txtEmail.text = user.email
        txtFbUrl.text = user.facebooklink
        //txtPhoneNo.text = user.contactnumber!
        
        //check mobile number available
        if user.contactnumber != 0{
            txtPhoneNo.text = String(user.contactnumber)
        }else{
            txtPhoneNo.text = ""
        }
        
        //set the url to the image view
        if let url = URL(string: user.profilepicUrl){
            imgProPic.kf.setImage(with: url)
        }
    }
    
}

