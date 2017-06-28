//
//  MainMenu.swift
//  SuhshiNeko2
//
//  Created by Cappillen on 6/27/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu: SKScene {
    
    //UI Connections
    var buttonPlay: MSButtonNode!
    var character: Character!
    var sushiBasePiece: SushiPiece!
    var sushiTower: [SushiPiece] = []
    var timer: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        //Set up scene here
        
        //Set UI Connections
        buttonPlay = self.childNode(withName: "buttonPlay") as! MSButtonNode
        //connect the sushi base pieces
        sushiBasePiece = self.childNode(withName: "sushiBasePiece") as! SushiPiece
        
        //Connect game objects
        character = self.childNode(withName: "character") as! Character
        
        buttonPlay.selectedHandler = {
            self.loadGame()
        }
        sushiBasePiece.connectChopsticks()
        
        addTowerPiece(side: .none)
        addTowerPiece(side: .right)
        addRandomPieces(total: 10)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func update(_ currentTime: TimeInterval) {
        if timer > 1.5 {
        let action = SKAction.run({
        let forePiece = self.sushiTower[1]
            if forePiece.side == self.character.side {
                if self.character.side == .right {
                    self.character.side = .left
                } else if self.character.side == .left {
                    self.character.side = .right
                }
            } else {
                self.character.side = self.character.side
            }
            
            //Grab the sushi above the sushibase it will always be first
            if let firstPiece = self.sushiTower.first {
                
                //remove from sushi tower array
                self.sushiTower.removeFirst()
                firstPiece.flip(self.character.side)
                
                //Add a new sushi piece to the top of the sushi tower
                self.addRandomPieces(total: 1)
            }
        })
        run(action)
            timer = 0
        }
        timer += 0.1
        moveTowerDown()
    }
    
    func addRandomPieces(total: Int) {
        //Add random piece to the sushi tower
        
        for _ in 1...total {
            
            //Need to access the last piece properties
            let lastPiece = sushiTower.last!
            
            //Need to ensure we don't create impossible sushi structures
            if lastPiece.side != .none  {
                addTowerPiece(side: .none)
            } else {
                
                //Random number generator TODO: it could be the random num that could be affect the no sushi
                let rand = arc4random_uniform(100)
                
                if rand < 45 {
                    //45% chance of getting a left piece
                    addTowerPiece(side: .left)
                } else if rand < 90 {
                    //45% chance of getting a right peice
                    addTowerPiece(side: .right)
                } else {
                    //10% chance of getting a sushi with none
                    addTowerPiece(side: .none)
                }
            }
        }
    }
    
    func addTowerPiece(side: Side) {
        //Add a new sushiPiece to the sushi tower
        
        //Copy original sushi piece
        let newPiece  = sushiBasePiece.copy() as! SushiPiece
        newPiece.connectChopsticks()
        
        //Access the last piece properties
        let lastPiece = sushiTower.last
        
        //Add on top of the last piece of the tower array, default first piece
        let lastPosition = lastPiece?.position ?? sushiBasePiece.position
        newPiece.position.x = lastPosition.x
        newPiece.position.y = lastPosition.y + 55
        
        //increment Z to ensure it's on top of the of the last piece, default on the first piece
        let lastZPosition = lastPiece?.zPosition ?? sushiBasePiece.zPosition
        newPiece.zPosition = lastZPosition + 1
        
        //Set side
        newPiece.side = side
        
        //Add the child to the scene TODO: check if adding the child can affect the apending to the array
        addChild(newPiece)
        
        //Add sushi piece the sushi tower
        sushiTower.append(newPiece)
    }
    
    func moveTowerDown() {
        var n: CGFloat = 0
        //loop through the shushi pieces in the array 55 times which is height of array
        for piece in sushiTower {
            print(n)
            //Instead of moving directly we move 50% of the distance
            let y = (n * 55) + 215
            piece.position.y -= (piece.position.y - y) * 0.5
            n += 1
        }
    }
    
    func loadGame() {
        //Grab reference to our sprite kit view
        
        //1) grab reference to our spriteKit view
        guard let skView = self.view as SKView! else {
            print("could not get SKView")
            return
        }
        //2) Load game scene
        guard let scene = GameScene(fileNamed: "GameScene") else {
            print("Could not make GameScene, check the name is spelled correctly")
            return
        }
        //Enusre the aspect mode is correct
        scene.scaleMode = .aspectFit
        //Show Debug
        skView.showsPhysics = true
        skView.showsDrawCount = true
        skView.showsFPS = true
        
        //4)
        skView.presentScene(scene)
        
    }
}
