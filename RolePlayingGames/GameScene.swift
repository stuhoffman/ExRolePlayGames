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
    case item = 2
    case attackArea = 4
    case npc = 8
    
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
    
    var transitionInProgress:Bool = false
    
    let defaults:UserDefaults = UserDefaults.standard
    
    var cameraFollowsPlayer:Bool = true
    var cameraXOffset:CGFloat = 0
    var cameraYOffset:CGFloat = 0
    var disableAttack:Bool = false
    
    //MARK: Did move to view
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        self.enumerateChildNodes(withName: "//*") {
            node, stop in
        
            if let theCamera:SKCameraNode = node as? SKCameraNode {
            self.camera = theCamera
            
            if (theCamera.childNode(withName: "InfoLabel1") is SKLabelNode ) {
                self.infoLabel1 = theCamera.childNode(withName: "InfoLabel1") as! SKLabelNode
                self.infoLabel1.text = ""
            }

            if (theCamera.childNode(withName: "InfoLabel2") is SKLabelNode ) {
                self.infoLabel2 = theCamera.childNode(withName: "InfoLabel2") as! SKLabelNode
                self.infoLabel2.text = ""
            }

            if (theCamera.childNode(withName: "SpeechIcon") is SKSpriteNode ) {
                self.speechIcon = theCamera.childNode(withName: "SpeechIcon") as! SKSpriteNode
                self.speechIcon.isHidden = true
            }
            
        }//if let theCamera
    }//enumerate child nodes
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
            //thePlayer.physicsBody?.collisionBitMask = BodyType.item.rawValue
            
            thePlayer.physicsBody?.contactTestBitMask = BodyType.item.rawValue
        }
        
        for node in self.children {
            
            if let someItem:WorldItem = node as? WorldItem {
                
                setUpItem(theItem:someItem)
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
        
        if (cameraFollowsPlayer == true) {
            
            self.camera?.position = CGPoint(x: thePlayer.position.x+cameraXOffset, y: thePlayer.position.y+cameraYOffset)
                
        }
        
    }
    
    
}



