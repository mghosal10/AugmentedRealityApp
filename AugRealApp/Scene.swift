//
//  Scene.swift
//  AugRealApp
//
//  Created by Madhumita Ghosal on 6/19/19.
//  Copyright © 2019 Madhumita Ghosal. All rights reserved.
//

import SpriteKit
import ARKit

class Scene: SKScene {
    
    var randomNo = Int()
    var ObjectToDisplay = ""
    
    var viewController: UIViewController?

    let animalLabel = SKLabelNode(text: "Animals found")
    let animalsPresentLabel = SKLabelNode(text: "Animals present here")
    let animalCountLabel = SKLabelNode(text: "0")
    let animalsInVicintyLabel = SKLabelNode(text: "0")
    var animalCounter = 0
    {
        didSet{
            self.animalsInVicintyLabel.text = "\(animalCounter)"
        }
    }
    var animalsFound = 0 {
        didSet{
            self.animalCountLabel.text = "\(animalsFound)"
        }
    }
    
    var creationTime : TimeInterval = 0
    
    override func didMove(to view: SKView) {
        
        randomNo = self.userData?.value(forKey: "randomNo") as! Int
        ObjectToDisplay = self.userData?.value(forKey: "ObjectToDisplay") as! String
        print("+++++++++++++++ \(ObjectToDisplay)")
        
        animalLabel.fontName = "Charter-Bold"
        animalLabel.fontSize = 18
        animalLabel.color = .white
        animalLabel.position = CGPoint(x: 70, y: 50)
        addChild(animalLabel)

        animalCountLabel.fontName = "Charter-Bold"
        animalCountLabel.fontSize = 30
        animalCountLabel.color = .white
        animalCountLabel.position = CGPoint(x: 40, y: 10)
        addChild(animalCountLabel)
        
        animalsPresentLabel.fontName = "Charter-Bold"
        animalsPresentLabel.fontSize = 18
        animalsPresentLabel.color = .white
        animalsPresentLabel.position = CGPoint(x: 270, y: 50)
        addChild(animalsPresentLabel)
        
        animalsInVicintyLabel.fontName = "Charter-Bold"
        animalsInVicintyLabel.fontSize = 30
        animalsInVicintyLabel.color = .white
        animalsInVicintyLabel.position = CGPoint(x: 270, y: 10)
        addChild(animalsInVicintyLabel)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if currentTime > creationTime
        {
            createObjectAnchor()
            creationTime = currentTime + TimeInterval(randomFloat(min: 2, max: 5))
        }
    }
    
    func randomFloat(min: Float, max: Float) -> Float {
        
        //CGFloat(Float(arc4random()) / Float(UINT32_MAX))6
        //return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
    func createObjectAnchor()
    {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        let degree = Float.pi * 2.0
        let rotateX = simd_float4x4(SCNMatrix4MakeRotation(degree * randomFloat(min: 0.0, max: 1.0), 1, 0, 0))
        let rotateY = simd_float4x4(SCNMatrix4MakeRotation(degree * randomFloat(min: 0.0, max: 1.0), 0, 1, 0))
        let rotation = simd_mul(rotateX, rotateY)
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1 - randomFloat(min: 0.0, max: 1.0)
        let transform = simd_mul(rotation, translation)
        let anchor = ARAnchor(transform: transform)
        sceneView.session.add(anchor: anchor)
        animalCounter += 1
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let animalSound = SKAction.playSoundFileNamed("\(ObjectToDisplay).mp3", waitForCompletion: false)
        
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        let hit = nodes(at: location)
        if let animalNode = hit.first{
            if animalNode.name == ObjectToDisplay
            {
                let animalFadeOut = SKAction.fadeOut(withDuration: 0.5)
                let remove = SKAction.removeFromParent()
                
                let groupActions = SKAction.group([animalFadeOut, animalSound])
                
                let actions = SKAction.sequence([groupActions, remove])
                animalNode.run(actions)
                animalCounter -= 1
                animalsFound += 1
                randomNo -= 1
                if randomNo == 0
                {
                    self.viewController?.performSegue(withIdentifier: "goToInfo", sender: self)
                }
            }
        }
    }
}
