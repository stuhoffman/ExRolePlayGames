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
    
    //powers of 2 (so keep multiplying by 2
    
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var thePlayer:SKSpriteNode = SKSpriteNode()
    var moveSpeed:TimeInterval = 1
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    let swipeUpRec = UISwipeGestureRecognizer()
    let swipeDownRec = UISwipeGestureRecognizer()
    let rotateRec = UIRotationGestureRecognizer()
    let tapRec = UITapGestureRecognizer()
    var currentLevel:String = "Grassland"

    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
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
    
    //MARK: ============= PROPERTY LIST

    func parsePropertyList() {
        
        let path = Bundle.main.path(forResource:"GameData", ofType: "plist")
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
        
        if (dict.object(forKey: "Levels") != nil) {
            if let levelDict:[String : Any] = dict.object(forKey: "Levels") as? [String : Any] {
                for (key, value) in levelDict {
                    if ( key == currentLevel) {
                        
                        if let levelData:[String : Any] = value as? [String : Any] {
                            
                            for (key, value) in levelData {
                                if (key == "NPC") {
                                    
                                    createNPCwithDict( theDict: value as! [String : Any] )
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func createNPCwithDict ( theDict:[String : Any]) {
        //print(theDict)
        for (key, value) in theDict {
            
            var theBaseImage:String = ""
            var theRange:String = ""
            let nickName:String = key
            
            if let NPCData:[String : Any] = value as? [String : Any] {
                for (key, value) in  NPCData {
                    if (key == "BaseImage") {
                        theBaseImage = value as! String
                        print("The baseImage = \(theBaseImage)")
                    } else if (key == "Range") {
                        theRange = value as! String
                    }
                }
            }
            let newNPC:NonPlayerCharacter = NonPlayerCharacter(imageNamed: theBaseImage)
            newNPC.name = nickName
            print("nickName = \(nickName)")
            newNPC.setupWithDict(theDict: value as! [String : Any] )
            self.addChild(newNPC)
            newNPC.zPosition = thePlayer.zPosition - 1
            newNPC.position = putWithinRange(nodeName: theRange)
            

        }
    }
    
    //MARK: ============= CALCULATE A RANGE AREA

    func putWithinRange(nodeName:String) -> CGPoint {
        
        var somePoint:CGPoint = CGPoint.zero
        
        for node in self.children {
            
            if (node.name == nodeName) {
                
                if let rangeNode:SKSpriteNode = node as? SKSpriteNode {
                    
                    let widthVar:UInt32 = UInt32(rangeNode.frame.size.width)
                    let heightVar:UInt32 = UInt32(rangeNode.frame.size.height)
                    
                    let randomX = arc4random_uniform( widthVar)
                    let randomY = arc4random_uniform( heightVar)
                    
                    let frameStartX = rangeNode.position.x - (rangeNode.size.width / 2      )
                    let frameStartY = rangeNode.position.y - (rangeNode.size.height / 2     )
                    
                    somePoint = CGPoint(x: frameStartX + CGFloat(randomX), y: frameStartY + CGFloat(randomY))
                }
                break
            }
        }
        return somePoint
    }
    //MARK: ============= ATTACK

    func attack() {
        let newAttack:AttackArea = AttackArea(imageNamed: "AttackCircle")
        newAttack.position = thePlayer.position
        newAttack.setUp()
        self.addChild(newAttack)
        newAttack.zPosition = thePlayer.zPosition - 1
        
        thePlayer.run(SKAction(named: "FrontAttack")! )
    }
    
    //MARK: ============= Gesture Recognizers
    
    func tappedView() {
        print("Attacking")
        attack()
        
    }
    
    
    func swipedRight() {
        
        print(" right")
        
        move(theXAmount: 100, theYAmount: 0, theAnimation: "WalkRight")
    }
    
    func swipedLeft() {
        
        print(" left")
        
        move(theXAmount: -100, theYAmount: 0, theAnimation: "WalkLeft")
    }
    
    func swipedUp() {
        
        print(" up")
        
        move(theXAmount: 0, theYAmount: 100, theAnimation: "WalkBack")
    }
    
    func swipedDown() {
        
        print(" down")
        
        move(theXAmount: 0, theYAmount: -100, theAnimation: "WalkFront")
        
        
    }
    
    
    
    
    
    func cleanUp(){
        
        //only need to call when presenting a different scene class
        
        for gesture in (self.view?.gestureRecognizers)! {
            
            self.view?.removeGestureRecognizer(gesture)
        }
        
        
    }
    
    
    
    func rotatedView(_ sender:UIRotationGestureRecognizer) {
        
        if (sender.state == .began) {
            
            print("rotation began")
            
        }
        if (sender.state == .changed) {
            
            print("rotation changed")
            
            //print(sender.rotation)
            
            let rotateAmount = Measurement(value: Double(sender.rotation), unit: UnitAngle.radians).converted(to: .degrees).value
            print(rotateAmount)
            
            thePlayer.zRotation = -sender.rotation
            
        }
        if (sender.state == .ended) {
            
            print("rotation ended")
            
            
        }
        
        
    }
    
    
    
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
        }
        
        
        
    }
    
    
    func move(theXAmount:CGFloat , theYAmount:CGFloat, theAnimation:String )  {
        
        
        let wait:SKAction = SKAction.wait(forDuration: 0.05)
        
        let walkAnimation:SKAction = SKAction(named: theAnimation, duration: moveSpeed )!
        
        let moveAction:SKAction = SKAction.moveBy(x: theXAmount, y: theYAmount, duration: moveSpeed )
        
        let group:SKAction = SKAction.group( [ walkAnimation, moveAction ] )
        
        let finish:SKAction = SKAction.run {
            
            //print ( "Finish")
            
            
        }
        
        
        let seq:SKAction = SKAction.sequence( [wait, group, finish] )
        
        
        
        thePlayer.run(seq)
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
        /*
         if ( pos.y > 0) {
         //top half touch
         
         } else {
         //bottom half touch
         
         moveDown()
         
         }
         */
        
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            
            self.touchDown(atPoint: t.location(in: self))
            
            break
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    //MARK: ======> Physics contacts
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.building.rawValue) {
            
            print ("touched a building")
        } else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.building.rawValue) {
            
            print ("touched a building")
            
            
            
        } else if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.castle.rawValue) {
            
            print ("touched a castle")
        } else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.castle.rawValue) {
            
            print ("touched a castle")
        }
        
        /////
        if (contact.bodyA.categoryBitMask == BodyType.attackArea.rawValue && contact.bodyB.categoryBitMask == BodyType.castle.rawValue) {
            print ("Hit the castle")
            contact.bodyB.node?.removeFromParent()
        } else if (contact.bodyA.categoryBitMask == BodyType.castle.rawValue && contact.bodyB.categoryBitMask == BodyType.attackArea.rawValue) {
            print ("Hit the castle")
            contact.bodyA.node?.removeFromParent()
        }
        
    }
    
    
    
    
}



