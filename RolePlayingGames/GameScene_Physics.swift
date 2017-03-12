//
//  GameScene_Physics.swift
//  RolePlayingGames
//
//  Created by Stuart Hoffman on 3/12/17.
//  Copyright © 2017 Justin Dike. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.building.rawValue) {
            
            //print ("touched a building")
        }
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.building.rawValue) {
            
            //print ("touched a building")
        }
        else if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.castle.rawValue) {
            
            //print ("touched a castle")
        }
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.castle.rawValue) {
            
            //print ("touched a castle")
        }
        else if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.npc.rawValue) {
            if let theNPC:NonPlayerCharacter = contact.bodyB.node as? NonPlayerCharacter {
                splitTextIntoFields( theText: theNPC.speak())
                theNPC.contactPlayer()
                
                speechIcon.isHidden = false
                speechIcon.texture = SKTexture(imageNamed: theNPC.speechIcon)
            }
        }
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.npc.rawValue) {
            if let theNPC:NonPlayerCharacter = contact.bodyA.node as? NonPlayerCharacter {
                splitTextIntoFields( theText: theNPC.speak())
                theNPC.contactPlayer()
                speechIcon.isHidden = false
                speechIcon.texture = SKTexture(imageNamed: theNPC.speechIcon)
            }
        }
        
        /////
        if (contact.bodyA.categoryBitMask == BodyType.attackArea.rawValue && contact.bodyB.categoryBitMask == BodyType.castle.rawValue) {
            print ("Hit the castle")
            contact.bodyB.node?.removeFromParent()
        }
        else if (contact.bodyA.categoryBitMask == BodyType.castle.rawValue && contact.bodyB.categoryBitMask == BodyType.attackArea.rawValue) {
            print ("Hit the castle")
            contact.bodyA.node?.removeFromParent()
        }
        
    }
    
    //MARK: Did End Contact
    
    func didEnd(_ contact: SKPhysicsContact){
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.npc.rawValue) {
            
            if let theNPC:NonPlayerCharacter = contact.bodyB.node as? NonPlayerCharacter {
                theNPC.endContactPlayer()
                infoLabel1.text = ""
                infoLabel2.text = ""
                
                speechIcon.isHidden = true
            }
        }
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.npc.rawValue) {
            
            if let theNPC:NonPlayerCharacter = contact.bodyA.node as? NonPlayerCharacter {
                theNPC.endContactPlayer()
                
                infoLabel1.text = ""
                infoLabel2.text = ""
                
                speechIcon.isHidden = true
                
            }
        }
    }//end func didEnd
    

}
