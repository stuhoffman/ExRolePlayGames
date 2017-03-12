//
//  NonPlayerCharacter.swift
//  RolePlayingGames
//
//  Created by Stuart Hoffman on 3/2/17.
//  Copyright © 2017 Justin Dike. All rights reserved.
//


import Foundation
import SpriteKit

class NonPlayerCharacter: SKSpriteNode {
    var frontName:String = " "
    var backName:String = " "
    var leftName:String = " "
    var rightName:String = " "
    
    var baseFrame:String = ""
    var isWalking:Bool = false
    var initialSpeechArray = [String]()
    var reminderSpeechArray = [String]()
    var alreadyContacted:Bool = false
    var currentSpeech:String = ""
    var speechIcon:String = ""
    var isCollidable:Bool = false
    
    func setupWithDict( theDict: [String: Any] ){
    
        
        for (key, value) in theDict
        {
            if (key == "Front") {
                frontName = value as! String
                //self.run(SKAction(named: frontName)!)
            }//front
            else if (key == "Back") {
                backName = value as! String
            }//back
            else if (key == "Left") {
                leftName = value as! String
            }//left
            else if (key == "Right") {
                rightName = value as! String
            }//right
            else if (key == "InitialSpeech") {
                if let theValue = value as? [String] {
                    initialSpeechArray = theValue
                }
                else if let theValue = value as? String {
                    initialSpeechArray.append(theValue)
                }
            }//initial
            else if (key == "ReminderSpeech") {
                if let theValue = value as? [String] {
                    reminderSpeechArray = theValue
                }
                else if let theValue = value as? String {
                    reminderSpeechArray.append(theValue)
                }
             }//remind
            else if (key == "Icon") {
                if let theValue = value as? String {
                    speechIcon = theValue
                }
            }//Icon
            else if (key == "Collidable") {
                if let theValue = value as? Bool {
                    isCollidable = theValue
                }
            }//Icon
    }//for
        
        let body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: self.frame.size.width/3, center: CGPoint.zero)
        self.physicsBody = body
        body.isDynamic = true
        body.affectedByGravity = false
        body.allowsRotation = false
        
        self.physicsBody?.categoryBitMask = BodyType.npc.rawValue
        
        self.physicsBody?.contactTestBitMask =  BodyType.player.rawValue
        
        if ( isCollidable == true) {
            self.physicsBody?.collisionBitMask =  BodyType.building.rawValue
            print("NPC is colliding with buildings = \(isCollidable)")
        } else {
            self.physicsBody?.collisionBitMask =  0
            print("NPC is colliding with buildings = \(isCollidable)")

        }
        walkRandom()
}//setup with dict
    
    func walkRandom() {
        let waitTime = arc4random_uniform(3)
        let wait:SKAction = SKAction.wait(forDuration: TimeInterval(waitTime))
        let endMove:SKAction = SKAction.run {
            self.walkRandom()
        }
        let randomNum = arc4random_uniform(4)
        
        if (randomNum == 0) {
            self.run(SKAction(named: frontName)! )
            let move:SKAction = SKAction.moveBy(x: 0, y: -50, duration: 1)
            self.run(SKAction.sequence([move, wait, endMove]))
        }
        else if (randomNum == 1) {
            self.run(SKAction(named: backName)! )
            let move:SKAction = SKAction.moveBy(x: 0, y: 50, duration: 1)
            self.run(SKAction.sequence([move, wait, endMove]))
        }
        else if (randomNum == 2) {
            self.run(SKAction(named: leftName)! )
            let move:SKAction = SKAction.moveBy(x: -50, y: 0, duration: 1)
            self.run(SKAction.sequence([move, wait, endMove]))
        }
        else {
            self.run(SKAction(named: rightName)! )
            let move:SKAction = SKAction.moveBy(x: 50, y: 0, duration: 1)
            self.run(SKAction.sequence([move, wait, endMove]))
        }
 }
        
    func contactPlayer() {
        isWalking = false
        self.removeAllActions()
        
        self.texture = SKTexture(imageNamed: baseFrame)
        
        if (alreadyContacted == false)  {
            alreadyContacted = true
            
        }
    }//contactPlayer
    
    func endContactPlayer() {
        
        if (isWalking == false) {
            isWalking = true
            walkRandom()
            
            currentSpeech = ""
        }
    }//endContactPlayer

    func speak() -> String {
        
        if ( currentSpeech == "") {
            //set a new val for currentSPeech
            if  (alreadyContacted == false) {
                let randomLine:UInt32 = arc4random_uniform( UInt32(initialSpeechArray.count) )
                currentSpeech = initialSpeechArray[ Int (randomLine) ]
            }  else  {
                let randomLine:UInt32 = arc4random_uniform( UInt32(reminderSpeechArray.count) )
                currentSpeech = reminderSpeechArray[ Int (randomLine) ]

            }
        }
        return currentSpeech
    }
}
