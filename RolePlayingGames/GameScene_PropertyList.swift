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
                                } else if (key == "Properties") {
                                    
                                    parseLevelSpecificProperties( theDict: value as! [String : Any] )
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
            
            newNPC.alreadyContacted = defaults.bool(forKey: currentLevel + nickName + "alreadyContacted")
        }
    }
    
    func parseLevelSpecificProperties( theDict:[String : Any]) {
        //print(theDict)
        for (key, value) in theDict {
            
            if (key == "CameraFollowsPlayer") {
                if (value is Bool) {
                    cameraFollowsPlayer = value as! Bool
                }
                
            } else  if (key == "CameraOffset") {
                if (value is String) {
                    let somePoint:CGPoint = CGPointFromString(value as! String )
                        cameraXOffset = somePoint.x
                        cameraYOffset = somePoint.y
                    
                }
                
            } else  if (key == "ContinuePoint") {
                if (value is Bool) {
                    if (value as! Bool == true) {
                        print("Detected continue point")
                        defaults.set(currentLevel, forKey: "ContinuePoint")
                    }
                }
                
            } else  if (key == "DisableAttack") {
                
                if (value as! Bool == true) {
                    disableAttack = value as! Bool
                }
            }

        }

 }//end func parseLevelSpecificProperties
    
    
            //MARK: Set up items...
            
            func setUpItem(theItem:WorldItem) {
                
                var foundItemInLevelDict:Bool = false
                let path = Bundle.main.path(forResource:"GameData", ofType: "plist")
                let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
                
                if (dict.object(forKey: "Levels") != nil) {
                    if let levelDict:[String : Any] = dict.object(forKey: "Levels") as? [String : Any] {
                        for (key, value) in levelDict {
                            if ( key == currentLevel) {
                                
                                if let levelData:[String : Any] = value as? [String : Any] {
                                    
                                    for (key, value) in levelData {
                                        if (key == "Items") {
                                            
                                            if let itemsData:[String : Any] = value as? [String : Any] {
                                                    for (key, value) in itemsData {
                                                        
                                                        if (key == theItem.name) {
                                                            foundItemInLevelDict = true
                                                            useDictWithWorldItem(theDict: value as! [String: Any], theItem: theItem)
                                                            print("Found Property key: \(key) to setup with property value: \(value)")
                                                                break
                                                        }//end if theItem.name
                                                }//end for key itemsData
                                            }//end itemsData
                                        }//end if "Items"
                                        break
                                    }//end for key in levelData
                                }//end levelData
                                break
                            }//end if currentLevel
                        }//end levelDict
                    }//end letLevelDict levels
                }//end if forKey:"Levels"
                
                if (foundItemInLevelDict == false) {
                    
                    if (dict.object(forKey: "Items") != nil) {
                        if let itemsData:[String : Any] = dict.object(forKey: "Items") as? [String : Any] {
                            
                            for (key, value) in itemsData {
                                
                                if (key == theItem.name) {
                                    useDictWithWorldItem(theDict: value as! [String: Any], theItem: theItem)
                                    print("Found Property key: \(key) to setup with property value: in Root")
                                    break
                                }//end if theItem.name
                            }//end for key itemsData

                        }//end if levelDict
                    }//end dict.object
                }//end foundItemInLevelDict == false
                
            }//end func setUpItem

    
    func useDictWithWorldItem( theDict:[String: Any] ,theItem:WorldItem) {
        print ( theDict)
    }

}
