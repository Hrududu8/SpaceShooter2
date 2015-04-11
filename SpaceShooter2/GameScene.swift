//
//  GameScene.swift
//  SpaceShooter2
//
//  Created by rukesh on 4/2/15.
//  Copyright (c) 2015 Rukesh. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    
    var shipHealth = 100
    
    func randomCGFloat(min: CGFloat, max: CGFloat)->CGFloat{
        return CGFloat(arc4random()) % max - min
    }
    
    
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        enumerateChildNodesWithName("asteriodNode", usingBlock: { (aNode : SKNode!, anUnsafePointer : UnsafeMutablePointer<ObjCBool>) -> Void in
            let safeNode = aNode as! SKSpriteNode
            safeNode.physicsBody?.velocity.dx = self.randomCGFloat(0.0, max: 200) - 100
            safeNode.physicsBody?.velocity.dy = self.randomCGFloat(0.0, max: 200) - 100
            safeNode.physicsBody?.restitution = 0.2
            safeNode.physicsBody?.categoryBitMask = 1
        })
        enumerateChildNodesWithName("shipNode", usingBlock: { (aNode : SKNode!, anUnsafePointer : UnsafeMutablePointer<ObjCBool>) -> Void in
            let safeNode = aNode as! SKSpriteNode
            safeNode.physicsBody?.velocity.dx =  self.randomCGFloat(0.0, max: 200) - 100
            safeNode.physicsBody?.velocity.dy = self.randomCGFloat(0.0, max: 200) - 100
            safeNode.physicsBody?.restitution = 0.2
            safeNode.physicsBody?.contactTestBitMask = 3
        })
        let node = childNodeWithName("scoreLabelNode")
        if let safeNode = node as? SKLabelNode {
            println("safeNode.alpha = \(safeNode.alpha)")
            
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
     
        /* Called when a touch begins
        the code should moved to init or didMoveToView becuase now it runs everytime there's a touch
        */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let nodes = nodesAtPoint(location)
            let rotate = SKAction.rotateByAngle(0.34, duration: 0.5)
            let rotateShip = SKAction.runAction(rotate, onChildWithName: "shipNode")
            //TODO change this from an enumearate ChildNodesWithName: using Block to something better
            enumerateChildNodesWithName("*Button", usingBlock: { (aNode : SKNode!, anUnsafePointer : UnsafeMutablePointer<ObjCBool>) -> Void in
                self.runAction(rotateShip)
        })
        }
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
            let safeNode = aNode as! SKSpriteNode
            if (safeNode.physicsBody?.linearDamping != 0){
                safeNode.physicsBody?.linearDamping = 0
            }
        }) 

    }
    func didBeginContact(contact: SKPhysicsContact){
        let asteriod = (contact.bodyA.node!.name == "asteriodNode") ? contact.bodyA : contact.bodyB
        shipHealth -= Int(asteriod.mass)
        println("ship healt = \(shipHealth)")
    }
}

