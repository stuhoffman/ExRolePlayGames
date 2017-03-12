//
//  GameScene_PropertyList.swift
//  RolePlayingGames
//
//  Created by Stuart Hoffman on 3/12/17.
//  Copyright © 2017 Justin Dike. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {

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
            newNPC.baseFrame = theBaseImage
            print("nickName = \(nickName)")
            newNPC.setupWithDict(theDict: value as! [String : Any] )
            self.addChild(newNPC)
            newNPC.zPosition = thePlayer.zPosition - 1
            newNPC.position = putWithinRange(nodeName: theRange)
            
            
        }
    }
    
}
