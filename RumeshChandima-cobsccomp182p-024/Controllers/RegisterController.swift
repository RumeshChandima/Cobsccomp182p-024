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
    @IBOutlet weak var txtPhoneNo: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        Auth.auth().createUser(withEmail:txtEmail.text!, password:txtPassword.text!) { authResult, error in
            
            
            if((error==nil)){
                Firestore.firestore().collection("Users").document((authResult?.user.uid)!).setData(["firstname":self.txtFirstName.text!,"lastname":self.txtLastName.text!,"email":self.txtEmail.text!,"contactnumber":self.txtPhoneNo.text!]) { err in
                    if let err = err {
                        self.showAlert(title: "Error", message: (error?.localizedDescription)!)
                        return
                    }
                    
                }
                
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
}
