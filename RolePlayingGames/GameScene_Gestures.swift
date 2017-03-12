//
//  GameScene_Gestures.swift
//  RolePlayingGames
//
//  Created by Stuart Hoffman on 3/12/17.
//  Copyright © 2017 Justin Dike. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    
    
    
    func tappedView() {
        print("Attacking")
        attack()
        
    }
    
    
    func swipedRight() {
        
        print(" right")
        
        move(theXAmount: 100, theYAmount: 0, theAnimation: "WalkRight")
    }
    
    func swipedLeft() {
        
        print(" left")
        
        move(theXAmount: -100, theYAmount: 0, theAnimation: "WalkLeft")
    }
    
    func swipedUp() {
        
        print(" up")
        
        move(theXAmount: 0, theYAmount: 100, theAnimation: "WalkBack")
    }
    
    func swipedDown() {
        
        print(" down")
        
        move(theXAmount: 0, theYAmount: -100, theAnimation: "WalkFront")
        
        
    }
    
    
    
    
    
    func cleanUp(){
        
        //only need to call when presenting a different scene class
        
        for gesture in (self.view?.gestureRecognizers)! {
            
            self.view?.removeGestureRecognizer(gesture)
        }
        
        
    }
    
    
    
    func rotatedView(_ sender:UIRotationGestureRecognizer) {
        
        if (sender.state == .began) {
            
            print("rotation began")
            
        }
        if (sender.state == .changed) {
            
            print("rotation changed")
            
            //print(sender.rotation)
            
            let rotateAmount = Measurement(value: Double(sender.rotation), unit: UnitAngle.radians).converted(to: .degrees).value
            print(rotateAmount)
            
            thePlayer.zRotation = -sender.rotation
            
        }
        if (sender.state == .ended) {
            
            print("rotation ended")
            
            
        }
        
        
    }
    

    
    
}
