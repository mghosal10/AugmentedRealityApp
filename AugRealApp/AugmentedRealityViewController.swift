//
//  AugmentedRealityViewController.swift
//  AugRealApp
//
//  Created by Madhumita Ghosal on 6/10/19.
//  Copyright © 2019 Madhumita Ghosal. All rights reserved.

import UIKit
import ARKit
import SpriteKit
import FirebaseDatabase
import Firebase

class AugmentedRealityViewController: UIViewController, ARSKViewDelegate{
    
    @IBOutlet weak var sceneView: ARSKView!
    
    var url = ""
    var detectedText = ""
    var location = ""
    var ObjectToDisplay = ""
    var randomNum = Int()
    var randomAnimalDisplay = Int()
    var dbRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self

        randomNum = randomInt(min: 1, max: 2)
        print(randomAnimalDisplay)
        
        let alert = UIAlertController(title: "Find \(randomNum) \(ObjectToDisplay)", message: "Tap on \(randomNum) \(ObjectToDisplay)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      
        let sceneSize = sceneView.bounds.size
        let scene = Scene(size: sceneSize)
        scene.scaleMode = .resizeFill
        
        scene.viewController = self
        
        scene.userData = NSMutableDictionary()
        scene.userData?.setObject(randomNum ?? "", forKey: "randomNo" as NSCopying)
        scene.userData?.setObject(ObjectToDisplay ?? "", forKey: "ObjectToDisplay" as NSCopying)
        
        sceneView.presentScene(scene)
        
        dbRef.child("location").child("wetland").child(String(randomAnimalDisplay)).child("location").setValue(location)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }

    func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    // MARK: - ARSKViewDelegate
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        let objectId = randomInt(min: 1, max: 3)
        
        let objectNode = SKSpriteNode(imageNamed: ObjectToDisplay.lowercased()) 
        objectNode.name = ObjectToDisplay
        return objectNode;
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var arInfo = segue.destination as! ARInfoViewController
        arInfo.detectedAnimal = ObjectToDisplay
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }   
}
