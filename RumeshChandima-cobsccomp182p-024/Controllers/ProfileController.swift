//
//  ProfileController.swift
//  RumeshChandima-cobsccomp182p-024
//
//  Created by Geeth Rangana on 2/24/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth
import SwiftyJSON
import Kingfisher
import LocalAuthentication

class ProfileController: UIViewController {
    
    let backgroundImageView = UIImageView()
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var txtFbUrl: UITextField!
    @IBOutlet weak var imgProPic: UIImageView!
    
    var UID: String?
    var LIKEHIT: String?
    
    var db : Firestore!
    var loggedUserId : String!
    
    func accessTouchIDOrFaceId(){
        let myContext = LAContext()
        let myLocalizedReasonString = "Biometric Authntication testing !! "
        
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    
                    DispatchQueue.main.async {
                        if success {
                            // User authenticated successfully, take appropriate action
                            self.showAlert(title: "Success", msg:  "Awesome!!... User authenticated successfully")
                        } else {
                            // User did not authenticate successfully, look at error and take appropriate action
                            self.showAlert(title: "Error", msg:  "Sorry!!... User did not authenticate successfully")
                        }
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
                showAlert(title: "Error", msg:  "Sorry!!.. Could not evaluate policy.")
            }
        } else {
            // Fallback on earlier versions
            
            showAlert(title: "Error", msg:  "Ooops!!.. This feature is not supported.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ViewUserDetails()
        
        
        accessTouchIDOrFaceId()
        
        db = Firestore.firestore()
        loggedUserId = UserDefaults.standard.string(forKey: UserDefaultsId.userIdUserdefault)
        
        //set the gesture to image selector
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTap(_:)))
        tap.numberOfTapsRequired = 1 //tap count to the gesture
        imgProPic.isUserInteractionEnabled = true //set image viewer eneble the user interation
        imgProPic.addGestureRecognizer(tap)//set the tap gesture to image viwer
        
        
        getData()
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    
    @IBAction func updateBtnClick(_ sender: Any) {
         uploadEdditedUserImage()
    }
    
    func uploadEdditedUserImage(){
        
        guard let imageData = imgProPic.image?.jpegData(compressionQuality: 0.2) else {return} //convert the image to data
        let imageRef = Storage.storage().reference().child("/UserImages/\(txtFirstName.text).jpg")//set the firebase cloud storage location and name
        
        let metaData = StorageMetadata() //set meta data
        metaData.contentType = "image/jpg"
        
        //upload the file
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                return
            }
            
            //get the download url
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    return
                }
                
                guard let url = url else {return}
                
                self.updateUserData(url: url.absoluteString)//upload the event data to the firestore
                
            })
            
        }
    }
    
    func updateUserData(url : String){
        
        var docRef : DocumentReference!
        
        let contactNumber = Int(txtPhoneNo.text ?? "") ?? 0
        
        var updatedUserDetails = User.init(firstname: txtFirstName.text ?? "", lastname: txtLastName.text ?? "", id: loggedUserId, email: txtEmail.text ?? "", contactnumber: contactNumber, facebooklink: txtFbUrl.text ?? "", profilepicUrl: url)
        
        docRef = Firestore.firestore().collection("Users").document(loggedUserId)
        updatedUserDetails.id = loggedUserId
        updatedUserDetails.email = Auth.auth().currentUser?.email ?? ""
        
        let data = User.modelToData(user: updatedUserDetails)
        
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            let alert = UIAlertController(title: "Success", message: "Successfully updated the user", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alert,animated: true, completion: nil)
        }
    }
    
    
    @objc func imgTap(_ tap : UITapGestureRecognizer){//image tap recognizer
        
        launchImagePicker()
    }
    
    
    func getData(){
        
        let docRef = db.collection("Users").document(loggedUserId)
        
        docRef.getDocument { (snap, error) in
        
            guard let data = snap?.data() else{return}
            print(data)
            let user = User.init(data: data)
            
            self.setDataToView(user: user)//set the data
        }
        
    }
    
    func setDataToView(user : User) {
        
        txtFirstName.text = user.firstname
        txtLastName.text = user.lastname
        txtEmail.text = user.email
        txtFbUrl.text = user.facebooklink
        //txtPhoneNo.text = user.contactnumber!
        
        //check mobile number available
        if user.contactnumber != 0{
            txtPhoneNo.text = String(user.contactnumber)
        }else{
            txtPhoneNo.text = ""
        }
        
        //set the url to the image view
        if let url = URL(string: user.profilepicUrl){
            imgProPic.kf.setImage(with: url)
        }
    }
    
 
    
    
}

extension ProfileController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func launchImagePicker(){//launching the media
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker,animated: true, completion: nil)
    }
    
    //after picking the media
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {return}
        imgProPic.contentMode = .scaleAspectFill
        imgProPic.image = image
        dismiss(animated: true, completion: nil)
    }
    
    //if imge selector cancelled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


