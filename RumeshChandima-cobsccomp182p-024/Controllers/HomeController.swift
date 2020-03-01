//
//  HomeController.swift
//  RumeshChandima-cobsccomp182p-024
//
//  Created by Geeth Rangana on 2/29/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import SwiftyJSON
import Kingfisher

class HomeController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnLogout: UIBarButtonItem!
    @IBOutlet weak var btnProfile: UIBarButtonItem!
    
    var events = [EventDC]()
    var db : Firestore!
    var listner : ListenerRegistration!
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let event = EventDC.init(id: "a123", title: "Event1", location: "Colombo", imageUrl: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.eventbrite.com%2F&psig=AOvVaw1bhX1RtEP2Ze_iLHwB8wUy&ust=1583046250550000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCMCS7ICZ9ucCFQAAAAAdAAAAABAP", description: "AAA", time: Timestamp(), goingCount: 1)
        
        //        let event = EventDC.init
        //
        //        events.append(event)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.EventCell, bundle: nil), forCellReuseIdentifier: Identifiers.EventCell)
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        
        if let _ = Auth.auth().currentUser{
            
            do{
                try Auth.auth().signOut()
                presentLoginController()
            }catch{
                debugPrint(error.localizedDescription)
            }
        }else{
            presentLoginController()
        }
    }
    
    fileprivate func presentLoginController(){
        
        let vc = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "Login")
        self.present(vc,animated: true,completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = Auth.auth().currentUser{
            btnLogout.title = "Logout"
            btnProfile.isEnabled = true
            getLoggedUserDetails()
            
        }else{
            btnLogout.title = "Login"
            btnProfile.isEnabled = false
        }
        
        setEventListner()//Initilizing the listner
    }
    
    func getLoggedUserDetails(){
        
        guard let email =  Auth.auth().currentUser?.email else { return }
        //get user details from firebase
        Firestore.firestore().collection("Users").whereField("email", isEqualTo: email)
            .getDocuments() { (snap, error) in
                if let error = error{
                    debugPrint(error.localizedDescription)
                    return
                }
                
                snap?.documents.forEach({ (doc) in
                    let data = doc.data()
                    let loggedUser = User.init(data: data)
                    
                    UserDefaults.standard.set(loggedUser.id, forKey: UserDefaultsId.userIdUserdefault)//save user id to user default
                    UserDefaults.standard.set(loggedUser.name, forKey: UserDefaultsId.userNameUserdefault)//save user name for user default
                    
                })
        }
    }
    
    func setEventListner() {//document listner
        
        listner = db.homeEvents.addSnapshotListener({ (snap, error) in
            if let error = error{
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
    
}

extension HomeController: UITableViewDelegate, UITableViewDataSource{
    
    func onEventAdded(change : DocumentChange, event : EventDC){//event added
        
        let newIndex = Int(change.newIndex)
        events.insert(event, at: newIndex)
        tableView.insertRows(at: [IndexPath(item: newIndex, section: 0)], with: .none)
    }
    
    func onEventModified(change : DocumentChange, event : EventDC) {//event modified
        
        if change.newIndex == change.oldIndex {//if the previous index is same as the current index
            
            let index = Int(change.newIndex)
            events[index] = event
            tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
            
        }else{//the item index has been changed from the prevous index
            
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            
            events.remove(at: oldIndex)
            events.insert(event, at: newIndex)
            
            tableView.moveRow(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
            
        }
    }
    
    func onEventRemoved(change : DocumentChange){//event removed
        let oldIndex = Int(change.oldIndex)
        events.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath(item: oldIndex, section: 0)], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.EventCell, for: indexPath) as? EventCell {
            cell.ConfigureCell(event: events[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
