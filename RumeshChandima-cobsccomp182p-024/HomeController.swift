//
//  HomeController.swift
//  RumeshChandima-cobsccomp182p-024
//
//  Created by Geeth Rangana on 2/26/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnViewProfile(_ sender: Any) {
        let vc = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "Profile")
        self.present(vc,animated: true,completion: nil)
    }
    
}

