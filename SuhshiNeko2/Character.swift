//
//  Character.swift
//  SuhshiNeko2
//
//  Created by Cappillen on 6/27/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import Foundation
import SpriteKit

class Character: SKSpriteNode {
    
    //Character side 
    var side: Side = .left {
        didSet {
            if side == .left {
                xScale = 1
                position.x = 70
            } else {
                //An easy way to flip the character image
                xScale = -1
                position.x = 252
            }
            
            let punch =  SKAction(named: "Punch")
            run(punch!)
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}
