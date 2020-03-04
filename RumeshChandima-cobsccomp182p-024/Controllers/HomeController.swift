//
//  HomeController.swift
//  RumeshChandima-cobsccomp182p-024
//
//  Created by Geeth Rangana on 2/29/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit
import Firebase
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
    var selectedUserEvent : EventDC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
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
        
        setEventListner()
    }
    
    func getLoggedUserDetails(){
        
        guard let email =  Auth.auth().currentUser?.email else { return }
        db.userByEmail(email: email)
            .getDocuments() { (snap, error) in
                if let error = error{
                    debugPrint(error.localizedDescription)
                    return
                }
                
                snap?.documents.forEach({ (doc) in
                    let data = doc.data()
                    let loggedUser = User.init(data: data)
                    
                    UserDefaults.standard.set(loggedUser.id, forKey: UserDefaultsId.userIdUserdefault)
                })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.EventCell , for: indexPath) as? EventCell {
            cell.ConfigureCell(event: events[indexPath.row])
            
            cell.userNameBtn.tag = indexPath.row
            cell.userNameBtn.addTarget(self, action: #selector(goToProfile(_:)), for: .touchUpInside)
            
            cell.participatingBtn.tag = indexPath.row
            cell.participatingBtn.addTarget(self, action: #selector(addGoing(_:)), for: .touchUpInside)
            
            cell.btnGoingCount.isHidden = true
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    
    @objc func goToProfile(_ sender : UIButton){
        
        if UserDefaults.standard.string(forKey: UserDefaultsId.userIdUserdefault) != "" {
            
            selectedUserEvent = events[sender.tag]
            performSegue(withIdentifier: Segues.toProile, sender: self)
        }else{
            
            showAlert(title: "Error", msg: "Sign in to view the profile details")
        }
    }
    
    @objc func addGoing(_ sender : UIButton){
        
        db.UpdateGoingCounts(eventID: events[sender.tag].id,completion:{ (response) in
            
            if(response)
            {
                self.showAlert(title: "Success", msg: "Your are added as a participant to this event")
                
                sender.setTitle("Going", for: .normal)
                sender.isEnabled = false
            }
        })
    }
    
    func setEventListner() {
        
        listner = db.homeEvents.addSnapshotListener({ (snap, error) in
            if let error = error{
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let event = EventDC.init(data: data)
                
                switch change.type{
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
    
    func onEventAdded(change : DocumentChange, event : EventDC){
        
        let newIndex = Int(change.newIndex)
        events.insert(event, at: newIndex)
        tableView.insertRows(at: [IndexPath(item: newIndex, section: 0)], with: .none)
    }
    
    func onEventModified(change : DocumentChange, event : EventDC) {
        
        if change.newIndex == change.oldIndex {
            
            let index = Int(change.newIndex)
            events[index] = event
            tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
            
        }else{
            
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            
            events.remove(at: oldIndex)
            events.insert(event, at: newIndex)
            
            tableView.moveRow(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
    }
    
    func onEventRemoved(change : DocumentChange){
        let oldIndex = Int(change.oldIndex)
        events.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath(item: oldIndex, section: 0)], with: .fade)
    }
}
