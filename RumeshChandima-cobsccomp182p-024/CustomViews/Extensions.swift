//
//  Extensions.swift
//  RumeshChandima-cobsccomp182p-024
//
//  Created by Geeth Rangana on 2/26/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit
import Firebase

extension String{
    var isNotEmpty : Bool{
        return !isEmpty
    }
}

extension UIViewController{
    
    func simpleAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
}

extension Firestore {
    
    var events : Query {//get all events
        return collection("Events")
    }
    
    var homeEvents : Query {//get all events order by the time stamp usefull to home page
        return collection("Events").order(by: "time", descending: true)
    }
    
    var users : Query {//user colleaction
        return collection("Users")
    }
    
    func userByEmail(email : String) -> Query {
        return collection("Users").whereField("email", isEqualTo: email)
    }
    
    func UserAddedEvents(userId : String) -> Query { //get the user added events to my events
        return collection("Events").whereField("publisherId", isEqualTo: userId).order(by: "time", descending: true)
    }
    
    func UpdateGoingCounts(eventID: String,completion:@escaping (Bool)->()){
        
        let eventDoc = collection("Events").document(eventID)
        
        eventDoc.getDocument { (document, error) in
            if(error == nil){
                
                var updatedEvent =  EventDC.init(data: (document?.data())!)
                
                var attendeesList = document!.get("goingUsers") as! [String]
                
                attendeesList.append(Auth.auth().currentUser!.uid)
                
                updatedEvent.goingUsers = attendeesList
                
                eventDoc.updateData(["goingUsers":attendeesList]){ err in
                    if let err = err {
                        //Alerts.showAlert(title: "Error", message: "Error uploading data: \(err.localizedDescription)", presentingVC: viewController)
                        print(err.localizedDescription)
                        completion(false)
                        return
                    }
                    
                    
                }
                
                completion(true)
                
            }
        }
       
    }
    
}

extension Auth {
    
    //error handling with firebase and view a alert box
    func handleFireAuthError(error: Error, viewController : UIViewController){
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            viewController.present(alert,animated: true,completion: nil)
        }
    }
}

extension AuthErrorCode{
    var errorMessage: String{
        switch self{
        case .emailAlreadyInUse:
            return "The email is alreadyin use with another person. Pick another email!"
        case .userNotFound:
            return "Account not found for the specified user. please check and try again"
        case .userDisabled:
            return "Your Account has been disabled, please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter valide email"
        case .networkError:
            return "Network Error Please try again."
        case .weakPassword:
            return "Your Password is too weak, The password must be 6 character long or more"
        case .wrongPassword:
            return "Your Password or Email is incorrect"
        default:
            return "Sorry, Somthing went wrong"
        }
    }
}


extension UIViewController {
    
    //custom alert messages for user
    func showAlert(title : String, msg : String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert,animated: true, completion: nil)
    }
}

