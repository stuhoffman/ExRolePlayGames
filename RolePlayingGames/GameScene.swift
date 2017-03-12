//
//  GameScene.swift
//  PlayAround
//
//  Created by Justin Dike on 1/10/17.
//  Copyright © 2017 Justin Dike. All rights reserved.
//

import SpriteKit
import GameplayKit

enum BodyType:UInt32{
    
    case player = 1
    case building = 2
    case castle = 4
    case attackArea = 8
    case npc = 16
    
    //powers of 2 (so keep multiplying by 2
    
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //MARK: Declarations
    var thePlayer:SKSpriteNode = SKSpriteNode()
    var moveSpeed:TimeInterval = 1
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    let swipeUpRec = UISwipeGestureRecognizer()
    let swipeDownRec = UISwipeGestureRecognizer()
    let rotateRec = UIRotationGestureRecognizer()
    let tapRec = UITapGestureRecognizer()
    var currentLevel:String = ""

    var infoLabel1:SKLabelNode = SKLabelNode()
    var infoLabel2:SKLabelNode = SKLabelNode()
    var speechIcon:SKSpriteNode = SKSpriteNode()
    
    
    //MARK: Did move to view
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        if let theCamera = self.childNode(withName: "TheCamera") as? SKCameraNode {
            self.camera = theCamera
            
            if (theCamera.childNode(withName: "InfoLabel1") is SKLabelNode ) {
                infoLabel1 = theCamera.childNode(withName: "InfoLabel1") as! SKLabelNode
                infoLabel1.text = ""
            }

            if (theCamera.childNode(withName: "InfoLabel2") is SKLabelNode ) {
                infoLabel2 = theCamera.childNode(withName: "InfoLabel2") as! SKLabelNode
                infoLabel2.text = ""
            }

            if (theCamera.childNode(withName: "SpeechIcon") is SKSpriteNode ) {
                speechIcon = theCamera.childNode(withName: "SpeechIcon") as! SKSpriteNode
                speechIcon.isHidden = true
            }
        }
        parsePropertyList()
        
         tapRec.addTarget(self, action:#selector(GameScene.tappedView))
         tapRec.numberOfTouchesRequired = 1
         tapRec.numberOfTapsRequired = 1
         self.view!.addGestureRecognizer(tapRec)
         
           /*
         rotateRec.addTarget(self, action: #selector (GameScene.rotatedView (_:) ))
         self.view!.addGestureRecognizer(rotateRec)
         
         */
        
        swipeRightRec.addTarget(self, action: #selector(GameScene.swipedRight) )
        swipeRightRec.direction = .right
        self.view!.addGestureRecognizer(swipeRightRec)
        
        swipeLeftRec.addTarget(self, action: #selector(GameScene.swipedLeft) )
        swipeLeftRec.direction = .left
        self.view!.addGestureRecognizer(swipeLeftRec)
        
        
        swipeUpRec.addTarget(self, action: #selector(GameScene.swipedUp) )
        swipeUpRec.direction = .up
        self.view!.addGestureRecognizer(swipeUpRec)
        
        swipeDownRec.addTarget(self, action: #selector(GameScene.swipedDown) )
        swipeDownRec.direction = .down
        self.view!.addGestureRecognizer(swipeDownRec)
        
        
        if let somePlayer:SKSpriteNode = self.childNode(withName: "Player") as? SKSpriteNode {
            
            thePlayer = somePlayer
            thePlayer.physicsBody?.isDynamic = true
            thePlayer.physicsBody?.affectedByGravity = false
            thePlayer.physicsBody?.categoryBitMask = BodyType.player.rawValue
            thePlayer.physicsBody?.collisionBitMask = BodyType.castle.rawValue
            
            thePlayer.physicsBody?.contactTestBitMask = BodyType.building.rawValue | BodyType.castle.rawValue
            
        }
        
        for node in self.children {
            
            if (node.name == "Building") {
                
                if (node is SKSpriteNode) {
                    
                    node.physicsBody?.categoryBitMask = BodyType.building.rawValue
                    node.physicsBody?.collisionBitMask = 0
                    
                    print ("found a building")
                }
            }
            
            if let aCastle:Castle = node as? Castle {
                
                aCastle.setUpCastle()
                aCastle.dudesInCastle = 5
                
            }
        }
    }
  
    //MARK: Update
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        for node in self.children {
            
            if (node.name == "Building") {
                
                if (node.position.y > thePlayer.position.y){
                    
                    node.zPosition = -100
                    
                } else {
                    
                    node.zPosition = 100
                }
            }
        }//for node loop
        
        self.camera?.position = thePlayer.position
    }
    
    
}



