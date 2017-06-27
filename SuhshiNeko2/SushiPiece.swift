//
//  Sushi.swift
//  SuhshiNeko2
//
//  Created by Cappillen on 6/27/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import Foundation
import SpriteKit

class SushiPiece: SKSpriteNode {
    
    //Sushi objects Chopsticks
    var rightChopstick: SKSpriteNode!
    var leftChopstick: SKSpriteNode!
    
    //Sushi type
    var side: Side = .none {
        didSet {
            switch side {
            case .left:
                //Shows the left chopstick only
                leftChopstick.isHidden = false
            case .right:
                //Shows the right chopstick only
                rightChopstick.isHidden = false
            case .none:
                //If none then don't show both chopsticks
                rightChopstick.isHidden = true
                leftChopstick.isHidden = true
            }
        }
    }
    func connectChopsticks() {
        //Connect our child chopstick nodes
        rightChopstick = childNode(withName: "rightChopstick") as! SKSpriteNode
        leftChopstick = childNode(withName: "leftChopstick") as! SKSpriteNode
        
        //Set the default sushi
        side = .none
    }
    
    func flip(_ side: Side) {
        //Flip the sushi our of the screen
        
        var actionName: String = ""
        
        if side == .left {
            actionName = "FlipRight"
        } else if side == .right {
            actionName = "FlipLeft"
        }
        
        //Load appropiate action
        let flip = SKAction(named: actionName)!
        
        //Create a node removal action
        let remove = SKAction.removeFromParent()
        
        //Creating the removal sequence flip then remove
        let sequence = SKAction.sequence([flip, remove])
        run(sequence)
        
    }
    //You are required to implement this for your subclass to work
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    //Your are required to implement this for your subclass to work
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
