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
    
    func handleFireAuthError(error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code){
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    func simpleAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)

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
