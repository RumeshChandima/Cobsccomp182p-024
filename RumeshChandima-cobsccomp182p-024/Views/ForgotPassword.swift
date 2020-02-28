//
//  ForgotPassword.swift
//  RumeshChandima-cobsccomp182p-024
//
//  Created by Geeth Rangana on 2/25/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit
import Firebase
import  FirebaseAuth

class ForgotPassword: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnReset(_ sender: Any) {

        Auth.auth().sendPasswordReset(withEmail: txtEmail.text!) { ( error) in
            if let error = error{
                debugPrint(error )
                
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
}
