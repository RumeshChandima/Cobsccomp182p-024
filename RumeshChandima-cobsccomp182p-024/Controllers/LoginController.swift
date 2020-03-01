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
        setBackground()
    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        let vc = ForgotPassword()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnCreateAccount(_ sender: Any) {
        let vc = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "Register")
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
        
        activityIndicator.startAnimating()//start the animation when button is clicked
        
        //firebase auth for loging
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, viewController:  self)//set the extention toncheck firebase validation
                self.activityIndicator.stopAnimating()
                return
            }
            else if user != nil {
                self.activityIndicator.stopAnimating()
                //self.simpleAlert(title: "Signed in successfuly", msg: "You have been successfully Signed In")
                
                let vc = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "Home")
                self.present(vc,animated: true,completion: nil)
                
            }
        }
    }
    
    func setBackground() {
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        backgroundImageView.image = UIImage(named: "background-NIBM1")
        view.sendSubviewToBack(backgroundImageView)
    }
}
