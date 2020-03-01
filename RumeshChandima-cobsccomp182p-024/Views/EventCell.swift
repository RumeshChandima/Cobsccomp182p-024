//
//  EventCell.swift
//  RumeshChandima-cobsccomp182p-024
//
//  Created by Geeth Rangana on 2/28/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit
import Kingfisher

class EventCell: UITableViewCell {
    
   // @IBOutlet weak var imgPosterProPic: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var btnGoingCount: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func ConfigureCell(event : EventDC) {
        lblTitle.text = event.title
        lblLocation.text = event.location
        lblDescription.text = event.description

//        if let url = URL(string: event.createrProPic){
//            imgPosterProPic.contentMode = .scaleAspectFit
//            imgPosterProPic.kf.setImage(with: url)
//        }
        
        if let url = URL(string: event.imageUrl){
            imgEvent.contentMode = .scaleAspectFit
            imgEvent.kf.setImage(with: url)
        }
    }

    @IBAction func btnGoing(_ sender: Any) {
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
