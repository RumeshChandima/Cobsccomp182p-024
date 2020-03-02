//
//  CreateEventController.swift
//  RumeshChandima-cobsccomp182p-024
//
//  Created by Geeth Rangana on 3/1/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class CreateEventController: UIViewController {
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var addCategoryBtn: UIButton!
    
    @IBOutlet weak var eventImageView: RoundedImageView!
    
    var loggedUserID : String!
    var loggedUserName : String!
    var eventDetails : EventDC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loggedUserID = UserDefaults.standard.string(forKey: UserDefaultsId.userIdUserdefault)
        loggedUserName = UserDefaults.standard.string(forKey: UserDefaultsId.userNameUserdefault)
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTap(_:)))
        tap.numberOfTapsRequired = 1
        eventImageView.isUserInteractionEnabled = true
        eventImageView.addGestureRecognizer(tap)
        
        if let event = eventDetails {
            txtTitle.text = event.title
            txtLocation.text = event.location
            txtDescription.text = event.description
            
            if let url = URL(string: event.imageUrl){
                eventImageView.contentMode = .scaleAspectFit
                eventImageView.kf.setImage(with: url)
            }
            
            addCategoryBtn.setTitle("Save Changes", for: .normal)
        }      
    }
    
    @objc func imgTap(_ tap : UITapGestureRecognizer){
        
        launchImagePicker()
    }
    
    @IBAction func eventSubmitButtonClick(_ sender: Any) {
        activityIndicator.startAnimating()
        uploadImageThenDocument()
        
    }
    
    func uploadImageThenDocument(){
        
        guard let image = eventImageView.image ,
            let eventTitle = txtTitle.text , eventTitle.isNotEmpty,
            let eventLocation = txtLocation.text , eventLocation.isNotEmpty,
            let eventDescription = txtDescription.text , eventDescription.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Must fill the all event details")
                return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {return}
        
        let imageRef = Storage.storage().reference().child("/EventImages/\(eventTitle).jpg")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload image")
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable to retrive image url")
                    return
                }
                
                guard let url = url else {return}
                
                self.uploadDocument(url: url.absoluteString)
                
            })
        }
    }
    
    func uploadDocument(url : String) {
        
        var docRef : DocumentReference!
        var event = EventDC.init(title: txtTitle.text ?? "",
                                 id: UUID().uuidString,
                                 description: txtDescription.text ?? "",
                                 location: txtLocation.text ?? "",
                                 publisher: "rumesh",
                                 imageUrl: url,
                                 time: Timestamp(),
                                 publisherId: "c48HxO10a1cT49S93jHt73AxhYr2",
                                 goingCount: [""])
        
        
        if let eventToEdit = eventDetails {
            docRef = Firestore.firestore().collection("Events").document(eventToEdit.id)
            event.id = eventToEdit.id
        }else{
            docRef = Firestore.firestore().collection("Events").document()
            event.id = docRef.documentID
        }
        
        let data = EventDC.modelToData(event: event)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to add new event")
                return
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func handleError(error : Error, msg : String){
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", msg: msg)
        self.activityIndicator.stopAnimating()
        
    }
    
}

extension CreateEventController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker(){
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker,animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {return}
        eventImageView.contentMode = .scaleAspectFit
        eventImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

