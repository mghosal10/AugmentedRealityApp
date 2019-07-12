//
//  MenuViewController.swift
//  AugRealApp
//
//  Created by Madhumita Ghosal on 6/7/19.
//  Copyright © 2019 Madhumita Ghosal. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func training_pressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToTraining", sender: self)
        
    }
}
