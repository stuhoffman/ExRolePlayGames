//
//  GameScene_Helpers.swift
//  RolePlayingGames
//
//  Created by Stuart Hoffman on 3/12/17.
//  Copyright © 2017 Justin Dike. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func splitTextIntoFields(theText:String) {
        let maxInOneLine:Int = 25
        var i:Int = 0
        
        var line1:String = ""
        var line2:String = ""
        
        var useLine2:Bool = false
        
        for letter in theText.characters {
            
            if (i > maxInOneLine && String(letter) == " ") {
                useLine2 = true
            }
            
            if (useLine2 == false){
                line1 = line1 + String(letter)
            } else {
                line2 = line2 + String(letter)
            }
            
            i += 1
        }
        
        infoLabel1.text  = line1
        infoLabel2.text = line2
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
    
    func loadLevel(theLevel:String ) {
            //pass in the level to start at
        if (transitionInProgress == false){
            transitionInProgress = true

            let fullSKSNameToLoad:String = SharedHelpers.checkIfSKSExists(baseSKSName: theLevel)
            
            if let scene = GameScene(fileNamed: fullSKSNameToLoad) {
                //cleanUpScene() to do
                scene.currentLevel = theLevel
                scene.scaleMode = .aspectFill
                
                let transition:SKTransition = SKTransition.fade(with:SKColor.black, duration:2)
                self.view?.presentScene(scene, transition:transition)
                
            } else {
                print("Could not find SKS File")
            }

        }
        
    }
    
    func rememberThis( withThing:String, toRemember:String) {
        
        defaults.set(true, forKey: currentLevel + withThing + toRemember)
        // ex: "GrasslandVillager1alreadyContacted" = true
        
    }
    
}
