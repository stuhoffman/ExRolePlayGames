//
//  GameScene_Player.swift
//  RolePlayingGames
//
//  Created by Stuart Hoffman on 3/12/17.
//  Copyright © 2017 Justin Dike. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    
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
    
    //MARK: ============= ATTACK
    
    func attack() {
        let newAttack:AttackArea = AttackArea(imageNamed: "AttackCircle")
        newAttack.position = thePlayer.position
        newAttack.setUp()
        self.addChild(newAttack)
        newAttack.zPosition = thePlayer.zPosition - 1
        
        thePlayer.run(SKAction(named: "FrontAttack")! )
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
    
    
   
    
}
