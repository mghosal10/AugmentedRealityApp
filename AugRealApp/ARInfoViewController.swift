//
//  ARInfoViewController.swift
//  AugRealApp
//
//  Created by Madhumita Ghosal on 6/18/19.
//  Copyright © 2019 Madhumita Ghosal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ARInfoViewController: UIViewController {
    
    var detectedAnimal = ""
    var species = ""
    var animal = ""
    var info = ""
    var url = ""
    var scientificName = ""
    var adultSize = ""
    var larvaeSize = ""
    var range = ""
    
    
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var animalLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var infoTextField: UITextView!
    @IBOutlet weak var animalImage: UIImageView!
    
    
    @IBOutlet weak var scientificNameLabel: UILabel!
    @IBOutlet weak var adultSizeLabel: UILabel!
    @IBOutlet weak var larvaeSizeLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAnimalData()
        
        // set UI
        speciesLabel.layer.borderColor = UIColor.black.cgColor
        speciesLabel.layer.borderWidth = 3.0
        speciesLabel.textColor = UIColor.white
        speciesLabel.backgroundColor = UIColor.gray
        speciesLabel.layer.cornerRadius = 7
        speciesLabel.font = UIFont(name: "MarkerFelt-Wide", size: 18.0)
        speciesLabel.textAlignment = .center
        
        animalLabel.textColor = UIColor.black
        animalLabel.font = UIFont(name: "MarkerFelt-Wide", size: 22.0)
        
        infoTextField.backgroundColor = UIColor.clear
        infoTextField.font = UIFont(name: "MarkerFelt-Thin", size: 16.0)
       
      
    }
    
    
    
    @IBAction func logOutPressed(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
           
            _ = navigationController?.popToRootViewController(animated: true)
            
           // self.performSegue(withIdentifier: "goToStartPage", sender: self)
            print("Successfully logged out")
            
        } catch let signOutErr {
            print("Failed to sign out:", signOutErr)
        }
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // retrieve animal data from database
    func getAnimalData()
    {
        var dbRef = Database.database().reference()
        
        dbRef.child("image data").queryOrdered(byChild: "animal name").queryEqual(toValue: detectedAnimal.lowercased()).observeSingleEvent(of: .childAdded, with: { (snapshot) in
            let dict = snapshot.value as! [String: Any]
            self.species = dict["species"] as! String
            self.animal = dict["display name"] as! String
            self.info = dict["info"] as! String
            self.url = dict["url"] as! String
            self.scientificName = dict["scientific name"] as! String
            self.adultSize = dict["adult size"] as! String
            self.larvaeSize = dict["larvae size"] as! String
            self.range = dict["range"] as! String
            
            
            // get image data
            self.animalImage.sd_setImage(with: URL(string:self.url), completed: nil)
            
            // set database values to respective text boxes
            self.speciesLabel.text = self.species
            self.animalLabel.text = self.animal
            self.infoTextField.text = self.info
            self.scientificNameLabel.text = self.scientificName
            self.adultSizeLabel.text = self.adultSize
            self.larvaeSizeLabel.text = self.larvaeSize
            self.rangeLabel.text = self.range
        })
    }
}
