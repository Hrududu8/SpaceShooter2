//
//  GameScene.swift
//  SpaceShooter2
//
//  Created by rukesh on 4/2/15.
//  Copyright (c) 2015 Rukesh. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    
    func randomCGFloat(min: CGFloat, max: CGFloat)->CGFloat{
        return CGFloat(arc4random()) % max - min
    }
    
    
    
    override func didMoveToView(view: SKView) {
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            //let location = touch.locationInNode(self)
        }
        
            enumerateChildNodesWithName("asteriodNode", usingBlock: { (aNode : SKNode!, anUnsafePointer : UnsafeMutablePointer<ObjCBool>) -> Void in
                let safeNode = aNode as SKSpriteNode
                safeNode.physicsBody?.velocity.dx = self.randomCGFloat(0.0, max: 200) - 100
                safeNode.physicsBody?.velocity.dy = self.randomCGFloat(0.0, max: 200) - 100
                safeNode.physicsBody?.restitution = 0.2
            })
            
        
    }
    func checkIfHeadingOffscreen(aNode: SKNode!, anUnsafePoint: UnsafeMutablePointer<ObjCBool>) -> Void {
        if (aNode.position.y < 10) {aNode.position.y = self.screenHeight - 10}
        if (aNode.position.y > (self.screenHeight - 10)) {aNode.position.y = 10}
        if (aNode.position.x < 10) {aNode.position.x = self.screenWidth - 10}
        if (aNode.position.x > (self.screenWidth - 10)) {aNode.position.x = 10}
    }
    
    override func update(currentTime: CFTimeInterval) {
        enumerateChildNodesWithName("//*", usingBlock: checkIfHeadingOffscreen)
        enumerateChildNodesWithName("asteriodNode", usingBlock: { (aNode : SKNode!, anUnsafePointer : UnsafeMutablePointer<ObjCBool>) -> Void in
            let safeNode = aNode as SKSpriteNode
            if (safeNode.physicsBody?.linearDamping != 0){
                safeNode.physicsBody?.linearDamping = 0
            }
        }) 

    }
}

