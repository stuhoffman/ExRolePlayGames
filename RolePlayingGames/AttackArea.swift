//
//  AttackArea.swift
//  PlayAround
//
//  Created by Stu Hoffman on 2/27/17.
//

import Foundation
import SpriteKit

class AttackArea: SKSpriteNode {
    
    func setUp() {
        
        let body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: self.frame.size.width/2, center: CGPoint.zero)
        self.physicsBody = body
        body.isDynamic = true
        body.affectedByGravity = false
        body.allowsRotation = false
        
        self.physicsBody?.categoryBitMask = BodyType.attackArea.rawValue
        self.physicsBody?.collisionBitMask =  0
        self.physicsBody?.contactTestBitMask =  BodyType.castle.rawValue
        
        
    }
    
    
    
}
