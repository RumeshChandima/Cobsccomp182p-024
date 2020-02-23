//
//  RegisterController.swift
//  RumeshChandima-cobsccomp182p-024
//
//  Created by Geeth Rangana on 2/23/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: UIViewController {
    
    let backgroundImageView = UIImageView()
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
    }
    
    @IBAction func btnRegister(_ sender: Any) {
    
        if(txtPassword.text! == txtConfirmPassword.text! && txtPassword.text!.count>=6){
            databaseOperation()
        }
        else{
            self.showAlert(title: "Warning", message: "Password Digits Should be Gretter Than 6 Or Password Not Matched")
        }
    }
    
    func databaseOperation(){
        
        ref = Database.database().reference()
        
        //        self.ref.child("df").child("articles") .setValue(["username": "testusername2"])
        self.ref.child("Users").childByAutoId().setValue(["FirstName":txtFirstName.text!,"LastName":txtLastName.text!,"Email":txtEmail.text!,"Password": txtPassword.text!])
        
        //create the user in authentication
        
        Auth.auth().createUser(withEmail:txtEmail.text!, password:txtPassword.text!) { authResult, error in
            
            
            if((error==nil)){
                
                self.showAlert(title: "Success", message: "User Registration Success !")
                
                let vc = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "Login")
                self.present(vc,animated: true,completion: nil)
                
                
                
            }
            else{
                
                self.showAlert(title: "Error", message: (error?.localizedDescription)!)
                
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
