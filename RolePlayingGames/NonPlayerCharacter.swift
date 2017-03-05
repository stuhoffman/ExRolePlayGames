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
    func setupWithDict( theDict: [String: Any] ){
    
        for (key, value) in theDict
        {
            if (key == "Front") {
                frontName = value as! String
                //self.run(SKAction(named: frontName)!)
            } else if (key == "Back") {
                backName = value as! String
            } else if (key == "Left") {
                leftName = value as! String
            } else if (key == "Right") {
                rightName = value as! String
            }
        }
        
        walkRandom()
    }
    
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
            
        } else if (randomNum == 0) {
            self.run(SKAction(named: backName)! )
            let move:SKAction = SKAction.moveBy(x: 0, y: 50, duration: 1)
            self.run(SKAction.sequence([move, wait, endMove]))
        } else if (randomNum == 0) {
            self.run(SKAction(named: leftName)! )
            let move:SKAction = SKAction.moveBy(x: -50, y: 0, duration: 1)
            self.run(SKAction.sequence([move, wait, endMove]))
        } else {
            self.run(SKAction(named: rightName)! )
            let move:SKAction = SKAction.moveBy(x: 50, y: 0, duration: 1)
            self.run(SKAction.sequence([move, wait, endMove]))
        }
        
        
        
    }
}
