//
//  MenuScene.swift
//  Trail Making Test
//
//  Created by Eduardo Pereira on 14/05/17.
//  Copyright © 2017 Eduardo Pereira. All rights reserved.
//

import SpriteKit
    
class MenuScene: SKScene {
    
    var testAButton = SKSpriteNode()
    var testBButton = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        testAButton = SKSpriteNode(imageNamed: "testAButton")
        testAButton.name = "testAButton"
        testAButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(testAButton)
        
        testBButton = SKSpriteNode(imageNamed: "testBButton")
        testBButton.name = "testBButton"
        testBButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 150)
        self.addChild(testBButton)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            
            //If anchor node is touched, set it as movable
            if let name = touchedNode.name{
                if name == "testAButton"{
                    let gameScene = TrailTestA(size: (view?.bounds.size)!)
                    let transition = SKTransition.fade(withDuration: 1)
                    view?.presentScene(gameScene, transition: transition)
                }
                if name == "testBButton"{
                    let gameScene = TrailTestB(size: (view?.bounds.size)!)
                    let transition = SKTransition.fade(withDuration: 1)
                    view?.presentScene(gameScene, transition: transition)
                }
            }
        }
    }
}
