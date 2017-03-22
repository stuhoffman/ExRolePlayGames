//
//  WorldItem.swift
//  PlayAround
//
//  Created by Justin Dike on 3/17/17.
//  Copyright © 2017 Stuart Hoffman. All rights reserved.
//

import Foundation
import SpriteKit

class WorldItem: SKSpriteNode {
    
    var isPortal:Bool = false
    var portalToLevel:String = " "
    var portalToWhere:String = " "
    func setupWithDict( theDict: [String: Any] ){
        
        
        for (key, value) in theDict
        {
            if (key == "PortalTo") {
                
                if let portalData:[String : Any] = value as? [String : Any] {
                    for (key, value) in portalData {
                        
                        if (key == "Level")    {
                            
                            if (value is String) {
                                portalToLevel = value as! String
                                isPortal = true
                                
                                print (portalToLevel)
                            }
                        } else if (key == "Where") {
                            
                            if (value is String) {
                                portalToWhere = value as! String
                                 isPortal = true
                                
                                print (portalToWhere)
                            }
                            
                        }
                    }

                }
            }//end if front
        }//end forloop
        
        self.physicsBody?.categoryBitMask = BodyType.item.rawValue
        self.physicsBody?.collisionBitMask =  BodyType.player.rawValue
        self.physicsBody?.contactTestBitMask =  BodyType.player.rawValue
        
    }//end func setupWithDict
    
    
}
