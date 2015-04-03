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
    
    
    override func didMoveToView(view: SKView) {
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            enumerateChildNodesWithName("asteriodNode", usingBlock: { (aNode : SKNode!, anUnsafePointer : UnsafeMutablePointer<ObjCBool>) -> Void in
                let safeNode = aNode as SKSpriteNode
                safeNode.physicsBody?.velocity.dx = 110
                safeNode.physicsBody?.velocity.dy = 220
            })
            
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        enumerateChildNodesWithName("asteriodNode", usingBlock: { (aNode : SKNode!, anUnsafePointer : UnsafeMutablePointer<ObjCBool>) -> Void in
            if (aNode.position.y < 10) {aNode.position.y = self.screenHeight - 10}
            if (aNode.position.y > (self.screenHeight - 10)) {aNode.position.y = 10}
            if (aNode.position.x < 10) {aNode.position.y = self.screenWidth - 10}
            if (aNode.position.x > (self.screenWidth - 10)) {aNode.position.x = 10}
            
        })
}
}

