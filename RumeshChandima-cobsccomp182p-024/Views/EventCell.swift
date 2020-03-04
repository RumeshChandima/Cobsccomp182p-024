//
//  EventCell.swift
//  RumeshChandima-cobsccomp182p-024
//
//  Created by Geeth Rangana on 2/28/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class EventCell: UITableViewCell {
    
    // @IBOutlet weak var imgPosterProPic: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var btnGoingCount: UIButton!
    
    @IBOutlet weak var  participatingBtn: UIButton!
    
    @IBOutlet weak var userNameBtn : UIButton!
    
    var db : Firestore!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        db = Firestore.firestore()
        
    }
    
    func ConfigureCell(event : EventDC) {
        lblTitle.text = event.title
        lblLocation.text = event.location
        lblDescription.text = event.description
        
        
        //        if let url = URL(string: event.createrProPic){
        //            imgPosterProPic.contentMode = .scaleAspectFit
        //            imgPosterProPic.kf.setImage(with: url)
        //        }
        
        if(Auth.auth().currentUser != nil){
            if(event.goingUsers.contains(Auth.auth().currentUser!.uid))
            {
                participatingBtn.setTitle("Going", for:UIControl.State.normal)
                participatingBtn.isEnabled = false
            }
            else{
                participatingBtn.setTitle("Not Going", for:UIControl.State.normal)
            }
        }
        else{
            participatingBtn.isHidden = true
        }
     
        
        
        if let url = URL(string: event.imageUrl){
            imgEvent.contentMode = .scaleAspectFit
            imgEvent.kf.setImage(with: url)
        }
        
        userNameBtn.setTitle(event.publisher, for: UIControl.State.normal)
        
    }
    
    @IBAction func btnGoing(_ sender: Any) {
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
