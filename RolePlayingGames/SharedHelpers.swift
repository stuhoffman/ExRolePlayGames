//
//  SharedHelpers.swift
//  RolePlayingGames
//
//  Created by Stuart Hoffman on 3/12/17.
//  Copyright © 2017 Justin Dike. All rights reserved.
//

import Foundation
import SpriteKit

class SharedHelpers {

    static func checkIfSKSExists( baseSKSName:String ) -> String  {
        var fullSKSNameToLoad:String = baseSKSName
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            if let _ = GameScene(fileNamed: baseSKSName + "Pad")  {
                fullSKSNameToLoad = baseSKSName + "Pad"
            }
        } else if (UIDevice.current.userInterfaceIdiom == .phone) {
            if let _ = GameScene(fileNamed: baseSKSName + "Phone")  {
                fullSKSNameToLoad = baseSKSName + "Phone"
            }

        }
        //tvos later
        
    
    return fullSKSNameToLoad
}

}
