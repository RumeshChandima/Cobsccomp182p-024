//
//  HomeController.swift
//  RumeshChandima-cobsccomp182p-024
//
//  Created by Geeth Rangana on 2/29/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit
import FirebaseFirestore
import SwiftyJSON
import Kingfisher

class HomeController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var events = [EventDC]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let event = EventDC.init(createrProPic: "", id: "a123", title: "Event1", location: "Colombo", imageUrl: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.eventbrite.com%2F&psig=AOvVaw1bhX1RtEP2Ze_iLHwB8wUy&ust=1583046250550000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCMCS7ICZ9ucCFQAAAAAdAAAAABAP", description: "AAA", time: Timestamp(), goingCount: 1)

        events.append(event)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.EventCell, bundle: nil), forCellReuseIdentifier: Identifiers.EventCell)
    }
    
    
    @IBAction func btnGoToProfile(_ sender: Any) {
        
    }
}

extension HomeController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.EventCell, for:
            indexPath) as? EventCell{
            cell.ConfigureCell(event: events[indexPath.row])
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
}
