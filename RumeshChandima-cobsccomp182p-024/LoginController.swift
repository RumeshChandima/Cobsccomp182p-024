//
//  LoginController.swift
//  RumeshChandima-cobsccomp182p-024
//
//  Created by Geeth Rangana on 2/23/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        let vc = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "ForgetPassword")
        self.present(vc,animated: true,completion: nil)
    }
    
    @IBAction func btnCreateAccount(_ sender: Any) {
        let vc = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "Register")
        self.present(vc,animated: true,completion: nil)
    }
    
    @IBAction func btnGoToWithoutLogin(_ sender: Any) {
        let vc = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "Home")
        self.present(vc,animated: true,completion: nil)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
            if error != nil {
                
                self.showAlert(title: "Error occured", message: "You have error with your mail and password")
            }
            else if user != nil {
                
                self.showAlert(title: "Signed in successfuly", message: "You have been successfully Signed In")
                
                let vc = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "Home")
                self.present(vc,animated: true,completion: nil)
                
            }
        }
    }
    
    func showAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
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
