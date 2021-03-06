//
//  LoginController.swift
//  RumeshChandima-cobsccomp182p-024
//
//  Created by Geeth Rangana on 2/23/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
class LoginController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        let vc = ForgotPassword()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnCreateAccount(_ sender: Any) {
        let vc = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "RegistrationNavigate")
        self.present(vc,animated: true,completion: nil)
    }
    
    @IBAction func btnGoToWithoutLogin(_ sender: Any) {
        let vc = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "HomeNavigate")
        self.present(vc,animated: true,completion: nil)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        
        guard let email = txtEmail.text, email.isNotEmpty ,
            let password = txtPassword.text, password.isNotEmpty
            else {
                simpleAlert(title: "Error", msg: "Please fill out all fields.")
                return
        }
        
        activityIndicator.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, viewController:  self)
                self.activityIndicator.stopAnimating()
                return
            }
            else if user != nil {
                self.activityIndicator.stopAnimating()
                
                let vc = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "HomeNavigate")
                self.present(vc,animated: true,completion: nil)
            }
        }
    }
}
