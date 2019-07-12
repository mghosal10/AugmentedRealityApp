//
//  RegisterViewController.swift
//  AugRealApp
//
//  Created by Madhumita Ghosal on 5/24/19.
//  Copyright © 2019 Madhumita Ghosal. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController{
    
    @IBOutlet weak var registerScrollView: UIScrollView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var password_confirm: UITextField!
    @IBOutlet weak var officialTraining: UITextField!
    @IBOutlet weak var natureImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        natureImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height + 300)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
       registerScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 300)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func register_pressed(_ sender: Any) {
    
        if password.text != password_confirm.text
        {
            let unmatched_password = UIAlertController(title: "Passwords don't match!", message: "Please re-type Password", preferredStyle: .alert)
            unmatched_password.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(unmatched_password, animated: true)
            
        }
        else if password.text == "" || firstName.text == "" || lastName.text == "" || email.text == "" || password.text == "" || password_confirm.text == "" || officialTraining.text == ""
        {
            let emptyTextAlert = UIAlertController(title: "Registration Failed!", message: "Please fill in all details", preferredStyle: .alert)
            emptyTextAlert.addAction(UIAlertAction(title: "Try Again?", style: .default, handler: nil))
            self.present(emptyTextAlert, animated: true)
        }
        else
        {
                Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
                
                if(error != nil)
                {
                    print(error!)
                    
                    
                    if(self.password.text!.count < 6)
                    {
                        let passwordLength = UIAlertController(title: "Passsword is too short!", message: "Length of the password has to be greater than 6 characters", preferredStyle: .alert)
                        passwordLength.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(passwordLength, animated: true)
                    }
                    else
                    {
                        let loginAlert = UIAlertController(title: "Registration Failed!", message: "Registration Not Successful", preferredStyle: .alert)
                        loginAlert.addAction(UIAlertAction(title: "Try Again?", style: .default, handler: nil))
                        self.present(loginAlert, animated: true)
                    }
                }
                else
                {
                    let user_parameters = ["first name": self.firstName.text!.lowercased(),
                                           "last name": self.lastName.text!.lowercased(),
                                           "email": self.email.text!.lowercased(),
                                           "official training details": self.officialTraining.text!.lowercased()]
                    
                    
                    Database.database().reference().child("users").childByAutoId().setValue(user_parameters)
                    
                    print("Registration Successful")
                    self.performSegue(withIdentifier: "goToSignIn", sender: self)
                }
            }
        }
    }
}
