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
    
    //text boxes
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    
    //activity indicator
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //button
    @IBOutlet weak var addCategoryBtn: UIButton!
    
    //image viewer
    @IBOutlet weak var eventImageView: RoundedImageView!
    
    //variable
    var loggedUserID : String!
    var loggedUserName : String!
    var eventDetails : EventDC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loggedUserID = UserDefaults.standard.string(forKey: UserDefaultsId.userIdUserdefault)
        loggedUserName = UserDefaults.standard.string(forKey: UserDefaultsId.userNameUserdefault)
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTap(_:))) //tap event inilize
        tap.numberOfTapsRequired = 1 // set tap count
        eventImageView.isUserInteractionEnabled = true //set user interaction true
        eventImageView.addGestureRecognizer(tap)//set the tap as a gesture to image view
        
        //if this is opening as edit form event details will nil
        if let event = eventDetails {
            txtTitle.text = event.title
            txtLocation.text = event.location
            txtDescription.text = event.description
            
            if let url = URL(string: event.imageUrl){//set the image to image viewer
                eventImageView.contentMode = .scaleAspectFit
                eventImageView.kf.setImage(with: url)
            }
            
            addCategoryBtn.setTitle("Save Changes", for: .normal)//change the button name
        }
        
        
        
        
    }
    
    @objc func imgTap(_ tap : UITapGestureRecognizer){//image tap recognizer
        
        launchImagePicker()
    }
    
    @IBAction func eventSubmitButtonClick(_ sender: Any) {
        activityIndicator.startAnimating()
        uploadImageThenDocument()
        
    }
    
    func uploadImageThenDocument(){
        
        //get all the data from text fields and image view
        guard let image = eventImageView.image ,
            let eventTitle = txtTitle.text , eventTitle.isNotEmpty,
            let eventLocation = txtLocation.text , eventLocation.isNotEmpty,
            let eventDescription = txtDescription.text , eventDescription.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Must fill the all event details")
                return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {return}//conveting to data
        
        let imageRef = Storage.storage().reference().child("/EventImages/\(eventTitle).jpg")//setting the file location and name
        
        let metaData = StorageMetadata()//set meta data
        metaData.contentType = "image/jpg"
        
        //upload the file
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload image")
                return
            }
            
            //get the download url
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable to retrive image url")
                    return
                }
                
                guard let url = url else {return}
                
                self.uploadDocument(url: url.absoluteString)//upload the event data to the firestore
                
            })
        }
    }
    
    func uploadDocument(url : String) {
        
        var docRef : DocumentReference!
        //set the datato the object
        var event = EventDC.init(title: txtTitle.text ?? "",
                                 id: "",
                                 description: txtDescription.text ?? "",
                                 location: txtLocation.text ?? "",
                                 publisher: loggedUserName,
                                 imageUrl: url,
                                 time: Timestamp(),
                                 publisherId: loggedUserID,
                                 goingCount: [""])
        
        
        if let eventToEdit = eventDetails {//edit event if event details is available
            docRef = Firestore.firestore().collection("Events").document(eventToEdit.id)
            event.id = eventToEdit.id
        }else{
            //create a new event
            docRef = Firestore.firestore().collection("Events").document()
            event.id = docRef.documentID
        }
        
        let data = EventDC.modelToData(event: event)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to add new event")
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func handleError(error : Error, msg : String){//fucntion in error
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", msg: msg)
        self.activityIndicator.stopAnimating()
        
    }
    
}

extension CreateEventController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker(){//launching the media
        
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

