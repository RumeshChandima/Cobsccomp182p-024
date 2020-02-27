//
//  ProfileController.swift
//  RumeshChandima-cobsccomp182p-024
//
//  Created by Geeth Rangana on 2/24/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON
import Kingfisher

class ProfileController: UIViewController {
    
    let backgroundImageView = UIImageView()
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    
    var UID: String?
    var LIKEHIT: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        ViewUserDetails()
    }
    
    func ViewUserDetails() {
        
        //self.prof_img.layer.cornerRadius = self.prof_img.bounds.height / 2
        //self.prof_img.clipsToBounds = true
        
        
        
        let ref = Database.database().reference().child("Users").child(UID!)
        ref.observe(.value, with: { snapshot in
            
            let dict = snapshot.value as? [String: AnyObject]
            let json = JSON(dict as Any)
            
            
            //let imageURL = URL(string: json["profileImageUrl"].stringValue)
            //self.prof_img.kf.setImage(with: imageURL)
            
            //self.DOB_txt.text = json["DOB"].stringValue
            self.txtFirstName.text = json["FirstName"].stringValue
            self.txtLastName.text = json["LastName"].stringValue

            
            //self.Phone_Num_txt.text = json["Phone_Number"].stringValue
            self.txtEmail.text = json["Email"].stringValue
            
            
            
        })
    }
    func setBackground() {
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        backgroundImageView.image = UIImage(named: "background-NIBM1")
        view.sendSubviewToBack(backgroundImageView)
    }
    
}
