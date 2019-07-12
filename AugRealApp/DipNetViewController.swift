//
//  DipNetViewController.swift
//  AugRealApp
//
//  Created by Madhumita Ghosal on 6/11/19.
//  Copyright © 2019 Madhumita Ghosal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class DipNetViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var speciesImage: UIImageView!
    
    @IBOutlet weak var speciesText: UITextField!
    @IBOutlet weak var numberOfSpecies: UITextField!
    @IBOutlet weak var commentsText: UITextView!
    
    @IBOutlet weak var dipNetScrollView: UIScrollView!
    @IBOutlet weak var natureImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        natureImg.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height + 450)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dipNetScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 450)
    }

    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
    
    @IBAction func LogOutInDipNet(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            _ = navigationController?.popToRootViewController(animated: true)
            print("Successfully logged out")
            
        } catch let signOutErr {
            print("Failed to sign out:", signOutErr)
        }
    }
  
    
    @IBAction func browse_pressed(_ sender: Any) {
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
            {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let prompt = UIAlertController(title: "Please choose one option", message: nil, preferredStyle: .actionSheet)
        prompt.addAction(cameraAction)
        prompt.addAction(photoLibraryAction)
        self.present(prompt, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("couldn't load image")
        }
        speciesImage.image = image
    }
    
    
    @IBAction func submitPressed(_ sender: Any) {
        
       
        if speciesText.text == "" || numberOfSpecies.text == "" || commentsText.text == ""
        {
            let emptyTextAlert = UIAlertController(title: "Submission Failed!", message: "Please enter data in all text fields!", preferredStyle: .alert)
            emptyTextAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyTextAlert, animated:true)
        }
        else
        {
            
            // upload data in the Firebase database and obtain the URL
            let storageRef = Storage.storage().reference().child("images/" + randomString(length: 15) + ".png")
            let imgData = speciesImage.image?.pngData()
            _ = storageRef.putData(imgData!, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    return
                }
                storageRef.downloadURL(completion: { (url, error) in
                    guard let downloadurl = url else {
                        return
                    }
                    var img_url = (url?.absoluteString)!
                    
                    
                    // write data into Firebase database
                    let dbRef = Database.database().reference()
                    let dipNet_parameters = ["species": self.speciesText.text!,
                                             "count": self.numberOfSpecies.text!,
                                             "comments": self.commentsText.text!,
                                             "url": img_url]
                    
                    dbRef.child("dip-net details").childByAutoId().setValue(dipNet_parameters)
                    
                })
            }
            
            let entrySucessfulAlert = UIAlertController(title: "Submitted!", message: "An entry has been created", preferredStyle: .alert)
            entrySucessfulAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(entrySucessfulAlert, animated:true)
        }
    }
}

