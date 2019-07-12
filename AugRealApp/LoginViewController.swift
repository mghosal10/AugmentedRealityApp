//
//  LoginViewController.swift
//  AugRealApp
//
//  Created by Madhumita Ghosal on 5/23/19.
//  Copyright © 2019 Madhumita Ghosal. All rights reserved.
//


import UIKit
import Firebase

class LoginViewController: UIViewController{
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    // login functionality
    @IBAction func login_pressed(_ sender: AnyObject) {
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            
            if error != nil
            {
                print(error!)
                let loginAlert = UIAlertController(title: "Invalid Credentials", message: "Incorrect Username/Password", preferredStyle: .alert)
                loginAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(loginAlert, animated: true)
            }
            else
            {
                print("Login successful")
                self.performSegue(withIdentifier: "goToMenu", sender: self)
            }
        }
    }

    
    // logout functionality
    func logout()
    {
        do
        {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            print("Successfully logged out")
           //s self.performSegue(withIdentifier: "", sender: self)
        }
        catch(let error)
        {
            print("Auth sign out failed! \n\(error)")
            
        }
    }
}

