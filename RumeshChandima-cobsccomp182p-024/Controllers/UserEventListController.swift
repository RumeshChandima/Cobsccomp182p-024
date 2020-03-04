//
//  UserEventListController.swift
//  RumeshChandima-cobsccomp182p-024
//
//  Created by Geeth Rangana on 3/1/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit
import Firebase

class UserEventListController: UIViewController {
    
    @IBOutlet weak var eventsTable: UITableView!
    
    var userEvents = [EventDC]()
    var db : Firestore!
    var listner : ListenerRegistration!
    var loggedUserId : String!
    var selectedEvent : EventDC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loggedUserId = UserDefaults.standard.string(forKey: UserDefaultsId.userIdUserdefault)
        db = Firestore.firestore()
        setTableView()
        
    }
    
    func setTableView(){
        eventsTable.delegate = self
        eventsTable.dataSource = self
        
        eventsTable.register(UINib(nibName: Identifiers.EventCell, bundle: nil), forCellReuseIdentifier: Identifiers.EventCell)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUserEventListner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listner.remove()
        userEvents.removeAll()
        eventsTable.reloadData()
    }
    
    func setUserEventListner(){
        
        listner = db.UserAddedEvents(userId : loggedUserId).addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let event = EventDC.init(data: data)
                
                switch change.type{//checking the change mode
                case .added:
                    self.onEventAdded(change: change, event: event)
                case .modified:
                    self.onEventModified(change: change, event: event)
                case .removed:
                    self.onEventRemoved(change: change)
                }
            })
        })
    }
    
    @IBAction func addEventBtnClick(_ sender: Any) {
    }
}

extension UserEventListController : UITableViewDelegate, UITableViewDataSource{
    
    func onEventAdded(change : DocumentChange, event : EventDC){
        
        let newIndex = Int(change.newIndex)
        userEvents.insert(event, at: newIndex)
        eventsTable.insertRows(at: [IndexPath(item: newIndex, section: 0)], with: .none)
    }
    
    func onEventModified(change : DocumentChange, event : EventDC) {
        
        if change.newIndex == change.oldIndex {
            
            let index = Int(change.newIndex)
            userEvents[index] = event
            eventsTable.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
            
        }else{
            
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            
            userEvents.remove(at: oldIndex)
            userEvents.insert(event, at: newIndex)
            
            eventsTable.moveRow(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
            
        }
    }
    
    func onEventRemoved(change : DocumentChange){
        let oldIndex = Int(change.oldIndex)
        userEvents.remove(at: oldIndex)
        eventsTable.deleteRows(at: [IndexPath(item: oldIndex, section: 0)], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.EventCell, for: indexPath) as? EventCell {
            cell.ConfigureCell(event: userEvents[indexPath.row])
            cell.btnGoingCount.tag = indexPath.row
            cell.btnGoingCount.setTitle("Edit", for: .normal)
            cell.btnGoingCount.addTarget(self, action: #selector(editEvent(_:)), for: .touchUpInside)
            
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func editEvent(_ sender : UIButton){
        selectedEvent = userEvents[sender.tag]
        performSegue(withIdentifier: Segues.addEditSeque, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.addEditSeque {
            if let destination = segue.destination as? CreateEventController {
                destination.eventDetails = selectedEvent
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
}

