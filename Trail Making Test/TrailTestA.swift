//
//  GameScene.swift
//  Trail Making Test
//
//  Created by Eduardo Pereira on 13/05/17.
//  Copyright © 2017 Eduardo Pereira. All rights reserved.
//

import SpriteKit

class TrailTestA: SKScene {
    
    var movableNode : SKNode?
    var anchor = SKSpriteNode()
    var originNode = SKSpriteNode()
    var destinyNode = SKSpriteNode()
    var destinyIndex : Int?
    var line = SKShapeNode()
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.backgroundColor = UIColor.white
        self.anchorPoint = CGPoint(x: 0, y: 1)
        
        //Populate screen with number nodes
        self.createNumberNodes()
        
        //Sets first origin and destiny node
        originNode = self.childNode(withName: "node1") as! SKSpriteNode
        destinyNode = self.childNode(withName: "node2") as! SKSpriteNode
        destinyIndex = 2
        
        //Creates anchor node to allow line movement
        anchor = SKSpriteNode(imageNamed: "anchor")
        anchor.name = "anchor"
        anchor.position = CGPoint(x: originNode.position.x, y: originNode.position.y + 70)
        anchor.zPosition = 1
        self.addChild(anchor)
        
        //Creates line from origin node to anchor
        let path = CGMutablePath()
        path.move(to: originNode.position)
        path.addLine(to: anchor.position)
        line.path = path
        line.lineWidth = 3
        line.fillColor = UIColor.black
        line.strokeColor = UIColor.black
        line.zPosition = destinyNode.zPosition + 1
        self.addChild(line)
    }
    
    //Handles screen touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            
            //If anchor node is touched, set it as movable
            if let name = touchedNode.name{
                if name == "anchor"{
                    movableNode = touchedNode
                    movableNode!.position = location
                }
            }
        }
    }
    
    //Handles touch movement
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //If anchor node is selected, update it's position and redraw the line
        if let touch = touches.first, movableNode != nil {
            movableNode!.position = touch.location(in: self)
            let location = touch.location(in: self)
            line.removeFromParent()
            let path = CGMutablePath()
            path.move(to: originNode.position)
            path.addLine(to: location)
            line.path = path
            line.lineWidth = 3
            line.fillColor = UIColor.black
            line.strokeColor = UIColor.black
            self.addChild(line)
        }
    }
    
    //Handles end of touch
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, movableNode != nil {
            movableNode!.position = touch.location(in: self)
            movableNode = nil
            
            //If the nodes are connected correctly
            //draw a line betwen origin and destiny node
            if(anchor.intersects(destinyNode)){
                //draws the correct line
                let correctPath = CGMutablePath()
                let correctLine = SKShapeNode()
                correctPath.move(to: originNode.position)
                correctPath.addLine(to: destinyNode.position)
                correctLine.path = correctPath
                correctLine.lineWidth = 3
                correctLine.fillColor = UIColor.black
                correctLine.strokeColor = UIColor.black
                correctLine.zPosition = destinyNode.zPosition - 1
                self.addChild(correctLine)
                
                //Sets anchor to it's new position and updates origin and destiny nodes
                // if test hasn't ended
                if (destinyIndex != 24){
                    originNode = self.childNode(withName: "node\(destinyIndex!)") as! SKSpriteNode
                    destinyNode = self.childNode(withName: "node\(destinyIndex!+1)") as! SKSpriteNode
                    destinyIndex! += 1
                    anchor.position = CGPoint(x: originNode.position.x, y: originNode.position.y + 75)
                    
                    line.removeFromParent()
                    let path = CGMutablePath()
                    path.move(to: originNode.position)
                    path.addLine(to: anchor.position)
                    line.path = path
                    line.lineWidth = 3
                    line.fillColor = UIColor.black
                    line.strokeColor = UIColor.black
                    line.zPosition = destinyNode.zPosition + 1
                    self.addChild(line)
                } else {
                    line.removeFromParent()
                    anchor.removeFromParent()
                    print("Test Finished")
                    let menuScene = MenuScene(size: (view?.bounds.size)!)
                    let transition = SKTransition.fade(withDuration: 1)
                    view?.presentScene(menuScene, transition: transition)

                }
            }
        }
    }
    
    //Handles touch cancelation
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            movableNode = nil
        }
    }
    
    func createNumberNodes(){
        var coordinates = [String]()
        
        // Gets nodes coordinates from text file
        if let path = Bundle.main.path(forResource: "TestA", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                coordinates = data.components(separatedBy: .whitespacesAndNewlines)
            } catch {
                print(error)
            }
        }
        
        //Populates screen with numbered nodes
        for i in 1..<25 {
            
            let imageName = "node\(i)"
            let sprite = SKSpriteNode(imageNamed: imageName)
            sprite.name = imageName
            
            let xPos = Float(coordinates[i*2])!
            let yPos = (Float(coordinates[i*2+1]))! * -1
            
            sprite.position = CGPoint(x: CGFloat(xPos) + sprite.size.width/2,
                                      y: CGFloat(yPos) - sprite.size.height/2)
            
            sprite.zPosition = CGFloat(i * -2)
            self.addChild(sprite)
        }

    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
