//
//  GameScene.swift
//  SpaceShooter2
//
//  Created by rukesh on 4/2/15.
//  Copyright (c) 2015 Rukesh. All rights reserved.
//

import SpriteKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    let kLaserSpeed : CGFloat = 100.0
    var scoreLabelNode = SKLabelNode()
    var shipHealth = 100
    var leftArrowButton = SKNode()
    var fireButton = SKNode()
    var shipNode = SKSpriteNode()
    
    required public init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    //convenience functions
    func randomCGFloat(min: CGFloat, max: CGFloat)->CGFloat{
        return CGFloat(arc4random()) % max - min
    }
    func degreesToRadians(angle: CGFloat)->CGFloat {
        return angle * 0.01745329252 //  = multiply by PI / 180
    }
    func radiansToDegrees(angle: CGFloat)->CGFloat {
        return angle * 57.296
    }
    
    
    override public func didMoveToView(view: SKView) {
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
            safeNode.physicsBody?.velocity.dx =  0
            safeNode.physicsBody?.velocity.dy = 0
            safeNode.physicsBody?.restitution = 0.2
            safeNode.physicsBody?.contactTestBitMask = 3
        })
        scoreLabelNode = childNodeWithName("scoreLabelNode") as! SKLabelNode
        leftArrowButton = childNodeWithName("leftArrowButton")!
        fireButton = childNodeWithName("fireButton")!
        shipNode = childNodeWithName("shipNode") as! SKSpriteNode

        
    }
    
    
    override public func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
     
        /* Called when a touch begins
        the code should moved to init or didMoveToView becuase now it runs everytime there's a touch
        */
        let rotate = SKAction.rotateByAngle(degreesToRadians(15.0), duration: 0.5)
        let rotateShip = SKAction.runAction(rotate, onChildWithName: "shipNode")
        
        
        
        
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(touchLocation)
            if (touchedNode == leftArrowButton){
                self.runAction(rotateShip)
                println("ship rotation = \(shipNode.zRotation + degreesToRadians(15)), sin = \(sin(shipNode.zRotation + degreesToRadians(15))), cos = \(cos(shipNode.zRotation + degreesToRadians(15)))")
                
            }
            if (touchedNode == fireButton){
                self.addChild(createLaser())
                }
        }
    }
    func createLaser()->SKSpriteNode {
        let laserBeam = SKSpriteNode(imageNamed: "laserBeam")
        laserBeam.name = "laserBeam"
        laserBeam.position.x = shipNode.position.x
        laserBeam.position.y = shipNode.position.y
        laserBeam.physicsBody = SKPhysicsBody(circleOfRadius: 10.0)
        laserBeam.physicsBody?.dynamic = true
        laserBeam.physicsBody?.affectedByGravity = false
        laserBeam.zRotation = shipNode.zRotation
        
        laserBeam.physicsBody?.velocity.dx = kLaserSpeed * sin(shipNode.zRotation ) * -1 //TODO apply an impulse instead?
        laserBeam.physicsBody?.velocity.dy = kLaserSpeed * cos(shipNode.zRotation) * 1
        println("in create Laser ship rotation = \(shipNode.zRotation), dx = \(laserBeam.physicsBody?.velocity.dx), dy = \(laserBeam.physicsBody?.velocity.dy)")
        return laserBeam
    }
    func checkIfHeadingOffscreen(aNode: SKNode!, anUnsafePoint: UnsafeMutablePointer<ObjCBool>) -> Void {
        if (aNode.position.y < 10) {aNode.position.y = self.screenHeight - 10}
        if (aNode.position.y > (self.screenHeight - 10)) {aNode.position.y = 10}
        if (aNode.position.x < 10) {aNode.position.x = self.screenWidth - 10}
        if (aNode.position.x > (self.screenWidth - 10)) {aNode.position.x = 10}
    }
    
    override public func update(currentTime: CFTimeInterval) {
        enumerateChildNodesWithName("asteriodNode", usingBlock: checkIfHeadingOffscreen)  // why is this line of code moving my labels?????
        enumerateChildNodesWithName("shipNode", usingBlock: checkIfHeadingOffscreen)
        enumerateChildNodesWithName("asteriodNode", usingBlock: { (aNode : SKNode!, anUnsafePointer : UnsafeMutablePointer<ObjCBool>) -> Void in
            let safeNode = aNode as! SKSpriteNode
            if (safeNode.physicsBody?.linearDamping != 0){
                safeNode.physicsBody?.linearDamping = 0
            }
        }) 
        
        
    }
    public func didBeginContact(contact: SKPhysicsContact){
        let asteriod = (contact.bodyA.node!.name == "asteriodNode") ? contact.bodyA : contact.bodyB
        shipHealth -= Int(asteriod.mass)
        scoreLabelNode.text = "\(shipHealth)"
    }
}

