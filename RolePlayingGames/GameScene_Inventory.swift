//
//  GameScene_Inventory.swift
//  RolePlayingGames
//
//  Created by Stuart Hoffman on 4/1/17.
//  Copyright © 2017 Justin Dike. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func sortRewards( rewards:[String: Any]) {
        
        for(key, value) in rewards {
            
            if (key == "Health") {
                
            }//end if health
            else if (key == "Weapon") {
                
            }//end if Weapon
            else if (key == "Currency") {
                
            }//end if Currency

            else if (key == "Class") {
                
            }//end if Class
            else {
                
                if (value is Int) {
                    addToInventory(newInventory: key, amount: value as! Int)
                }//end if Int
            }//end else

        }//end for loop
    }//end func sortRewards
    
    
    func addToInventory(newInventory:String, amount:(Int)) {
        
        if (defaults.integer(forKey: newInventory) != 0) {
            
            let currentAmount:Int = defaults.integer(forKey: newInventory)
            let newAmount:Int = currentAmount + amount
            
            print("set \(newAmount) for \(newInventory)")
            
            defaults.set(newAmount, forKey:newInventory)
            checkForItemThatMightOpen(newInventory: newInventory, amount: newAmount)
        }//end if
        else {

            print("set \(amount) for \(newInventory)")
            
            defaults.set(amount, forKey:newInventory)
            checkForItemThatMightOpen(newInventory: newInventory, amount: amount)
            
        }
    }//end func addToInventory
    
    
    func checkForItemThatMightOpen( newInventory:String, amount:Int) {
        
        for node in self.children {
            
            if let theItem:WorldItem = node as? WorldItem {
                
                if (theItem.isOpen == false ) {
                    
                    if (newInventory == theItem.requiredThing)  {
                        
                        if (amount >= theItem.requiredAmount) {
                            
                            if (theItem.unlockedTextArray.count > 0) {
                                
                                splitTextIntoFields(theText: theItem.getUnlockedInfo() )
                                theItem.open()
                                
                                
                            }//end unlocked array > 0
                        }//end amount >=
                        
                    }//end requiredThing
                }//end if open
                
            }//end if let
        }//end for
        
    }//end checkForItemThatMightOpen
    
    
}
