//
//  GameObjectNode.swift
//  SpaceShooter2
//
//  Created by rukesh on 4/3/15.
//  Copyright (c) 2015 Rukesh. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class GameObjectNode: SKNode {
    var shouldDelete : Bool = false
    func collisionWithPlayer(player: SKNode) -> Bool {
        return false
    }
    
    func checkNodeRemoval(playerY: CGFloat){
        if playerY > self.position.y + 300.0 {
            self.removeFromParent()
        }
    }
    func nodeName()->String{
        return "Generic Node -- this should never be"
    }
    
}



class asteriodNode: GameObjectNode {
        override init(){
            super.init()
            if (self.physicsBody?.angularVelocity == 0) {
                self.physicsBody?.angularVelocity = 50
            }
                }
    
    
    override func nodeName()->String{
        return "AsteriodNode"
    }
}







