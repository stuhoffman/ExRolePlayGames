//
//  GameViewController.swift
//  PlayAround
//
//  Created by Justin Dike on 1/10/17.
//  Copyright © 2017 Justin Dike. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    let defaults:UserDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        var initialLevel:String = "Grassland"

        if (defaults.object(forKey: "ContinuePoint") != nil) {
            initialLevel = defaults.string(forKey: "ContinuePoint")!
            print("InitialLevel = \(initialLevel)")
        }
        
        let fullSKSNameToLoad:String = SharedHelpers.checkIfSKSExists(baseSKSName: initialLevel)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = GameScene(fileNamed: fullSKSNameToLoad) {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.currentLevel = initialLevel
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsPhysics = false
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
