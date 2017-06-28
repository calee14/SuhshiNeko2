//
//  GameScene.swift
//  SuhshiNeko2
//
//  Created by Cappillen on 6/26/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Side {
    case left, none, right
}

//Tracking gameState
enum GameState {
    case title, ready, playing, gameOver
}


class GameScene: SKScene {
    
    //Game objects
    var sushiBasePiece: SushiPiece!
    //Set reference to the character
    var character: Character!
    //Sushie tower array
    var sushiTower: [SushiPiece] = []
    //game management
    var state: GameState = .title
    //play button
    var playButton: MSButtonNode!
    //HealthBar
    var healthBar: SKSpriteNode!
    //ScoreLabel
    var scoreLabel: SKLabelNode!
    //GameOver text
    var gameText: SKLabelNode!
    var overText: SKLabelNode!
    var playAgain: SKLabelNode!
    
    var health: CGFloat = 1.0 {
        didSet {
            //Scale healthbar between 0.0 -> 1.0 e.g. 0 < 100
            if health > 1.0 { health = 1.0 }
            
            healthBar.xScale = health
        }
    }
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        //connect the sushi base pieces
        sushiBasePiece = self.childNode(withName: "sushiBasePiece") as! SushiPiece
        
        //Connect game objects
        character = self.childNode(withName: "character") as! Character
        healthBar = self.childNode(withName: "healthBar") as! SKSpriteNode
        //UI connections
        playButton = self.childNode(withName: "buttonPlay") as! MSButtonNode
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        gameText = self.childNode(withName: "gameText") as! SKLabelNode
        overText = self.childNode(withName: "overText") as! SKLabelNode
        playAgain = self.childNode(withName: "playAgain") as! SKLabelNode
        
        state = .ready
        
        sushiBasePiece.connectChopsticks()
        
        addTowerPiece(side: .none)
        addTowerPiece(side: .right)
        addRandomPieces(total: 10)
        
        //Hide Text
        gameText.alpha = 0
        overText.alpha = 0
        playAgain.alpha = 0
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Called when touches begins
        
        //Disabling touch if game is not playing
        if state == .gameOver || state == .title { return }
        
        if state == .ready {
            state = .playing
        }
        
        //Find the first touch
        let touch = touches.first!
        
        //Find the location of the touch in the scene
        let location = touch.location(in: self)
        
        //Was the touch left or right 
        if location.x > size.width / 2 {
            //if the touch was on the right side
            character.side = .right
        } else {
            //if the touch was on the left side
            character.side = .left
        }
        
        //Grab the sushi above the sushibase it will always be first
        if let firstPiece = sushiTower.first {
            
            //Check if the character side is the same as the sushi
            if character.side == firstPiece.side {
                
                gameOver()
                
                //no need to run the rest of the code 
                return
            }
            
            health += 0.1
            score += 1
            
            //remove from sushi tower array
            sushiTower.removeFirst()
            firstPiece.flip(character.side)
            
            //Add a new sushi piece to the top of the sushi tower
            addRandomPieces(total: 1)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        //Sneak in the game over text
        if state == .gameOver && gameText.alpha != 1 {
            gameText.alpha += 0.05
            overText.alpha += 0.05
            playAgain.alpha += 0.05
        }
        
        if state != .playing {
            return
        }
        //Decrease health
        health -= 0.01
        
        //has the player ran out of health
        if health < 0 {
            gameOver()
        }
        
        //Ease in the
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
    
    func gameOver() {
        //Game over
        state = .gameOver
        
        //Turn all the sushi peices red
        for sushi in sushiTower {
            sushi.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.5))
        }
        
        //make the base turn red
        sushiBasePiece.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.5))
        
        //Make the playa red
        character.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.5))
        
        //Change the play button selection handler
        playButton.selectedHandler = {
            
            //Grab reference to the skView
            let skView = self.view as SKView!
            
            //Load Game Scene 
            guard let scene = GameScene(fileNamed: "GameScene") as GameScene! else {
                return
            }
            
            //Enure correct aspectmode
            scene.scaleMode = .aspectFill
            
            //Restart GameScene
            skView?.presentScene(scene)
            
        }
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
}
