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
    var portalToLevel:String = ""
    var portalToWhere:String = ""
    
    var requiredThing:String = ""
    var requiredAmount:Int = 0
    var deductOnEntry:Bool = false
    var timeToOpen:TimeInterval = 0
    
    var lockedTextArray = [String]()
    var unlockedTextArray = [String]()
    var openTextArray = [String]()
    
    var isOpen:Bool = true
    let defaults:UserDefaults = UserDefaults.standard
    var currentInfo:String = ""
    var currentUnlockedText:String = ""
    
    var openAnimation:String = ""
    var openImage:String = ""
    
    var rewardDictionary = [String : Any]()
    
    var neverRewardAgain:Bool = false
    var neverShowAgain:Bool = false
    var deleteBody:Bool = false
    var deleteFromLevel:Bool = false
    
    
    //MARK: Setup With Dictionary
    func setupWithDict( theDict: [String: Any] ){
        for (key, value) in theDict
        {
            if (key == "Requires") {
                isOpen = false
                if (value is [String : Any]) {
                    sortRequirements(theDict: value as! [String : Any] )
                }//end value is
            }//end if requires
            else if (key == "Text") {
                
                if (value is [String : Any]) {
                    sortText(theDict: value as! [String : Any] )
                }//end value is text
            } //end
            else if (key == "Rewards") {
                
                if (value is [String : Any]) {
                    sortRewards(theDict: value as! [String : Any] )
                }//end value is text
            } //end
            else if (key == "AfterContact") {
                
                if (value is [String : Any]) {
                    sortAfterContact(theDict: value as! [String : Any] )
                }//end value is text
            } //end
            else if (key == "PortalTo") {
                
                if (value is [String : Any]) {
                    
                    sortPortalto(theDict: value as! [String : Any] )

                 }//end portal data
            }//end portal to
            else if (key == "Appearance") {
                
                if (value is [String : Any]) {
                    
                    sortAppearance(theDict: value as! [String : Any] )
                    
                }//end portal data
            }//end portal to

        }//end forloop in dict
        
        self.physicsBody?.categoryBitMask = BodyType.item.rawValue
        self.physicsBody?.collisionBitMask =  BodyType.player.rawValue
        self.physicsBody?.contactTestBitMask =  BodyType.player.rawValue
        
        checkRequirements()
        
    }//end func setupWithDict
    
    
    func checkRequirements() {
        
        if (defaults.integer(forKey: requiredThing) >= requiredAmount   ) {
            
            open()
            print("\(self.name) is open ")
        } else {
            isOpen = false
            print("\(self.name) is NOT open ")
        }

        
    }//end func checkRequirements
    
    func sortPortalto(theDict: [String: Any]){
        
        for (key, value) in theDict {
            
            if (key == "Level")    {
                
                if (value is String) {
                    portalToLevel = value as! String
                    isPortal = true
                    
                   // print (portalToLevel)
                }//end value is
            } else if (key == "Where") {
                
                if (value is String) {
                    portalToWhere = value as! String
                    isPortal = true
                    
                    //print (portalToWhere)
                }//end value is
                
            }//end where
        }//end for key

    }//end func sortPortalTo

    func sortRewards(theDict: [String: Any]){

        //rewardDictionary = theDict
        //or do it this way
        for (key, value) in theDict {
            
            rewardDictionary[key] = value
            
        }//for loop
        
    }//end func sortRewards
    
    
    func sortAppearance(theDict: [String: Any]){
        
        for (key, value) in theDict {
            
            if (key == "OpenImage")    {
                
                if (value is String) {
                    
                openImage = value as! String
                }//end value is
            } else if (key == "OpenAnimation") {
                
                if (value is String) {
                    
                openAnimation = value as! String
                    
                }//end value is
                
            }//end where
        }//end for key
        
    }//end func sortAppearance

    func sortAfterContact(theDict: [String: Any]){
        
        for (key, value) in theDict {
            
            if (key == "NeverRewardAgain")    {
                
                if (value is String) {
                    
                    neverRewardAgain = value as! Bool
                }//end value is
            }//end neverRewardAgain
            else if (key == "NeverShowAgain") {
                
                if (value is String) {
                    
                    neverShowAgain = value as! Bool
                    
                }//end value is
                
            }//end neverShowAgain
            else if (key == "DeleteFromLevel") {
                
                if (value is String) {
                    
                    deleteFromLevel = value as! Bool
                    
                }//end value is
                
            }//end deleteFromLevel
            else if (key == "DeleteBody") {
                
                if (value is String) {
                    
                    deleteBody = value as! Bool
                    
                }//end value is
                
            }//end deleteBody
            
        }//end for key
        
    }//end func sortAfterContact

    func sortRequirements(theDict: [String: Any]) {
        
        for (key, value) in theDict {
            
            if (key == "Inventory" || key == "Thing") {
                
                if (value is String) {
                    
                    requiredThing = value as! String
                }//end if value is string
            }//end Inventory or Thing
            else if (key == "Amount" ) {
                    
                    if (value is Int) {
                        
                        requiredAmount = value as! Int
                }//end if value is Int
            }//end key = amount
            else if (key == "DeductOnEntry" ) {
                    
                    if (value is Bool) {
                        
                        deductOnEntry = value as! Bool
                    }//end if bool
            }//end DeductOnEntry
            else if (key == "TimeToOpen" ) {
                
                if (value is TimeInterval) {
                    
                    timeToOpen = value as! TimeInterval
                }//end if bool
            }//end TimeToOpen
    
        }//end for loop theDict
        
    }//end func sortRequirments
    
    func sortText(theDict: [String: Any]) {
        
        for (key, value) in theDict {
            
            if (key == "Locked") {
                
                print("LOCKED")
                if  let theValue = value as? [String]{
                    lockedTextArray = theValue
                }//end if value is string
                else if let theValue = value as? String{
                    lockedTextArray.append(theValue)
                }//end else
            }//end key = Locked
            else if (key == "Unlocked" ) {
                
                print("UN LOCKED")
                if  let theValue = value as? [String]{
                    unlockedTextArray = theValue
                }//end if value is string
                else if let theValue = value as? String {
                    unlockedTextArray.append(theValue)
                }//end else
            }//end key = Unlocked
            else if (key == "Open" ) {
                
                print("OPEN")
                if  let theValue = value as? [String]{
                    openTextArray = theValue
                }//end if value is string
                else if let theValue = value as? String {
                    openTextArray.append(theValue)
                }//end else
            }//end key = Open
        }//end for loop
    }//end func sortText
    
    func getInfo()-> String {
        
        if (currentInfo == "") {
            
            if (isOpen == false) {
                
                if (lockedTextArray.count > 0) {
                    
                    let randomLine:UInt32 = arc4random_uniform( UInt32( lockedTextArray.count  )  )
                    currentInfo = lockedTextArray[  Int (randomLine) ]
                    
                }
            
            }//end if false
            else {
                
                if (openTextArray.count > 0) {
                    
                    let randomLine:UInt32 = arc4random_uniform( UInt32( openTextArray.count  )  )
                    currentInfo = openTextArray[  Int (randomLine) ]
                    
                }
            }//end else
            
            let wait:SKAction = SKAction.wait(forDuration: 3)
            let run:SKAction = SKAction.run {
                
                self.currentInfo = ""
            }//end let run
            
            self.run(SKAction.sequence([wait, run]))
            
        }//end if currentinfo
        
        return currentInfo
    }//end func getInfo
    
    
    func open() {
        //will run when a req is met to open the item.
        
        isOpen = true
        
        if (openAnimation != "") {
            
            self.run(SKAction(named: openAnimation)!)
        }//end if
        else if (openImage != "") {
            
            self.texture = SKTexture(imageNamed: openImage)
        }
        
    }
    
    func getUnlockedInfo()-> String {
        
        if (currentUnlockedText == "") {
            
            let randomLine:UInt32 = arc4random_uniform( UInt32( unlockedTextArray.count  )  )
            currentUnlockedText = unlockedTextArray[  Int (randomLine) ]

            
            let wait:SKAction = SKAction.wait(forDuration: 3)
            let run:SKAction = SKAction.run {
                
                self.currentUnlockedText = ""
            }//end let run
            
            self.run(SKAction.sequence([wait, run]))
            
        }//end if currentUnlockedText
        
        return currentUnlockedText
    }//end func getUnlockedInfo
    
    func afterOpenContact() {
        
        if (isOpen == true) {
            if (deleteBody == true) {
                self.physicsBody = nil
            }//end if delete from body
            else if (deleteFromLevel == true) {
                self.removeFromParent()
            }//end else delete from level
            
            if (deductOnEntry == true) {
                if (defaults.integer(forKey: requiredThing) != 0) {
                    
                    let currentAmount:Int = defaults.integer(forKey: requiredThing)
                    let newAmount:Int = currentAmount - requiredAmount
                    
                    defaults.set(newAmount, forKey:requiredThing)
                    
                    print("set \(newAmount) for \(requiredThing)")
                    
                }
            }
            
        }
    }//end func afterOpencontact

    
}//end class
