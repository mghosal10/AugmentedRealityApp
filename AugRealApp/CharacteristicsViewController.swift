//
//  CharacteristicsViewController.swift
//  AugRealApp
//
//  Created by Madhumita Ghosal on 6/10/19.
//  Copyright © 2019 Madhumita Ghosal. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CharacteristicsViewController: UIViewController {
    
    @IBOutlet weak var animalName: UILabel!
    
    let dbRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func goToPreviousPage(_ sender: Any) {
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
}
