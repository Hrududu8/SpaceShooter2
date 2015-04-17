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
    
    let scoreLabelNode = SKLabelNode()
    var shipHealth = 100
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        scoreLabelNode.position = CGPoint(x: 40, y: 40)
        scoreLabelNode.name = "shello"
        scoreLabelNode.fontColor = SKColor.whiteColor()
        scoreLabelNode.fontSize = 30
        scoreLabelNode.zPosition = 30 
        scoreLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        scoreLabelNode.text = "hello world"
        addChild(scoreLabelNode)
        
    }
    
        func randomCGFloat(min: CGFloat, max: CGFloat)->CGFloat{
        return CGFloat(arc4random()) % max - min
    }
    
    
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        enumerateChildNodesWithName("asteriodNode", usingBlock: { (aNode : SKNode!, anUnsafePointer : UnsafeMutablePointer<ObjCBool>) -> Void in
            let safeNode = aNode as! SKSpriteNode
            safeNode.physicsBody?.velocity.dx = self.randomCGFloat(0.0, max: 200) - 100
            safeNode.physicsBody?.velocity.dy = self.randomCGFloat(0.0, max: 200) - 100
            safeNode.physicsBody?.angularVelocity = self.randomCGFloat(0, max: 4) - 2
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
        
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
     
        /* Called when a touch begins
        the code should moved to init or didMoveToView becuase now it runs everytime there's a touch
        */
        let rotate = SKAction.rotateByAngle(0.34, duration: 0.5)
        let rotateShip = SKAction.runAction(rotate, onChildWithName: "shipNode")
        let buttonParentNode = childNodeWithName("buttonParentNode")
        let leftArrowButton = buttonParentNode!.childNodeWithName("leftArrowButton")
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if (leftArrowButton!.containsPoint(location)){ //TODO:  fix this so it recognizes when the touches are in the box
                self.runAction(rotateShip)
            }
        }
    }
    func checkIfHeadingOffscreen(aNode: SKNode!, anUnsafePoint: UnsafeMutablePointer<ObjCBool>) -> Void {
        if (aNode.position.y < 10) {aNode.position.y = self.screenHeight - 10}
        if (aNode.position.y > (self.screenHeight - 10)) {aNode.position.y = 10}
        if (aNode.position.x < 10) {aNode.position.x = self.screenWidth - 10}
        if (aNode.position.x > (self.screenWidth - 10)) {aNode.position.x = 10}
    }
    
    func spriteDebug(aNode: SKNode!, anUnsafePointer: UnsafeMutablePointer<ObjCBool>)->Void {
        println("--\(aNode.name) at zPosition \(aNode.zPosition)")
        }
        
        
    
    override func update(currentTime: CFTimeInterval) {
        enumerateChildNodesWithName("//*", usingBlock: checkIfHeadingOffscreen)  // why is this line of code moving my labels?????
        enumerateChildNodesWithName("//*", usingBlock: spriteDebug)
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

