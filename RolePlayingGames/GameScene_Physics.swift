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
        
     if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.npc.rawValue) {
            if let theNPC:NonPlayerCharacter = contact.bodyB.node as? NonPlayerCharacter {
                splitTextIntoFields( theText: theNPC.speak())
                theNPC.contactPlayer()
                
                rememberThis(withThing: theNPC.name!, toRemember: "alreadyContacted")
                
                speechIcon.isHidden = false
                speechIcon.texture = SKTexture(imageNamed: theNPC.speechIcon)
            }
        }
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.npc.rawValue) {
            if let theNPC:NonPlayerCharacter = contact.bodyA.node as? NonPlayerCharacter {
                splitTextIntoFields( theText: theNPC.speak())
                theNPC.contactPlayer()
                
                rememberThis(withThing: theNPC.name!, toRemember: "alreadyContacted")
                
                speechIcon.isHidden = false
                speechIcon.texture = SKTexture(imageNamed: theNPC.speechIcon)
            }
     } else if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.item.rawValue) {
        print("BODY B CONTACT PERSON AND ITEM")
        if let theItem:WorldItem = contact.bodyB.node as? WorldItem {
            
            loadLevel(theLevel: "Grassland", toWhere: "")
            contactWithItem(theItem: theItem)
            
        }
     }
     else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.item.rawValue) {
        print("BODY A CONTACT PERSON AND ITEM")
        if let theItem:WorldItem = contact.bodyA.node as? WorldItem {
            loadLevel(theLevel: "Dungeon", toWhere: "")
            contactWithItem(theItem: theItem)
        }
    }

 
        
    }//end func didBegin
    
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
    
    func contactWithItem( theItem:WorldItem ) {
        print("contactWithItem starting")
        if (theItem.isPortal == true) {
            
            if ( theItem.portalToLevel != "")   {
                print("The portalToLevel = \(theItem.portalToLevel)")
                //must goto another level
                if ( theItem.portalToWhere != "")   {
                    print("The portalToWhere= \(theItem.portalToWhere)")

                    loadLevel(theLevel: theItem.portalToLevel, toWhere: theItem.portalToWhere)
                } else {
                    
                    loadLevel(theLevel: theItem.portalToLevel, toWhere: " ")
                }
            } else  if ( theItem.portalToWhere != "")  {
                
                //must got somwhere in this level
            }
        }
        
    }
    
}
