//
//  GameScene.swift
//  TestGame
//
//  Created by Jiwoo Lee on 3/17/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

protocol GameSceneDelegate {
    func shareScore(_ score: Int)
    func gameEnded()
    func gameStarted()
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let kanyeCategory: UInt32 = 0x1 << 1
    let shoeCategory: UInt32 = 0x1 << 2
    let fakeShoeCategory: UInt32 = 0x1 << 3
    let wallCategory: UInt32 = 0x1 << 4
    
    var score = 0
    
    var gameDelegate: GameSceneDelegate?
    
    var gameOver = false
    
    var xFactor = 2.0
    var yFactor = 1.0
    
    var kanye: SKSpriteNode?
    var motionManager: CMMotionManager?
    var randomShoeGenerator: GKRandomDistribution?
    
    var moveAndRemove: SKAction?
    
    var gameScore: SKLabelNode?
    
    var restartButton: SKSpriteNode?
    var shareButton: SKSpriteNode?
    var gameOverLabel: SKLabelNode?
    
    func createScene() {
        if let del = gameDelegate {
            del.gameStarted()
        }
        xFactor = 2.0
        yFactor = 1.0
        score = 0
        gameOver = false
        self.physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
        randomShoeGenerator = GKRandomDistribution(lowestValue: 1, highestValue: 6)
        backgroundColor = UIColor.white
        
        kanye = SKSpriteNode(imageNamed: "kanye")
        kanye?.setScale(0.25)
        kanye?.position = CGPoint(x: 0, y: 0)
        kanye?.physicsBody = SKPhysicsBody(circleOfRadius: (kanye?.size.width)!/2)
        kanye?.physicsBody?.categoryBitMask = kanyeCategory
        kanye?.physicsBody?.contactTestBitMask = shoeCategory
        kanye?.physicsBody?.collisionBitMask = shoeCategory | wallCategory
        kanye?.physicsBody?.isDynamic = true
        kanye?.physicsBody?.affectedByGravity = true
        kanye?.physicsBody?.allowsRotation = false
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -(self.view?.frame.width)!/2, y: -(self.view?.frame.height)!/2, width: (self.view?.frame.width)!, height: (self.view?.frame.height)!))
        self.physicsBody?.categoryBitMask = wallCategory
        
        gameScore = SKLabelNode(fontNamed: "Avenir-Light")
        gameScore?.text = "Score: \(score)"
        gameScore?.position = CGPoint(x: -(self.view?.frame.width)!/2, y: (self.view?.frame.height)!/2 - 80)
        gameScore?.horizontalAlignmentMode = .left
        gameScore?.fontSize = 30
        gameScore?.fontColor = UIColor.black
        
        self.addChild(gameScore!)
        
        self.addChild(kanye!)
        
        let spawn = SKAction.run {
            self.generateSneaker()
        }
        let delay = SKAction.wait(forDuration: 2.0)
        let shoeSpawning = SKAction.repeatForever(SKAction.sequence([spawn,delay]))
        
        self.run(shoeSpawning)
        
        let distanceToMove = self.frame.height
        let moveShoe = SKAction.moveBy(x: 0, y: -distanceToMove, duration: TimeInterval(CGFloat(0.02) * distanceToMove))
        let removeShoe = SKAction.removeFromParent()
        moveAndRemove = SKAction.sequence([moveShoe,removeShoe])
    }
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameOver {
            // cite this http://stackoverflow.com/questions/26225236/swift-spritekit-adding-button-programaticly
            let touch = touches.first
            let touchLocation = touch!.location(in: self.view! as SKView)
            let adjustedPosition = CGPoint(x: touchLocation.x - (self.view?.frame.width)!/2, y: touchLocation.y - (self.view?.frame.height)!/2)
            print(touchLocation)
            print(adjustedPosition)
            if (restartButton?.contains(adjustedPosition))! {
                restart()
            }
            if (shareButton?.contains(adjustedPosition))! {
                shareScore()
            }
            
        }
    }
    
    func restart() {
        self.removeAllChildren()
        self.removeAllActions()
        createScene()
    }
    
    func shareScore() {
        if let del = gameDelegate {
            del.shareScore(score)
        }
    }
    
    func generateSneaker() {
        let randomX = CGFloat(Float(arc4random()) / Float(UINT32_MAX))*(self.view?.frame.width)! - (self.view?.frame.width)!/2
        let randomY = CGFloat(Float(arc4random()) / Float(UINT32_MAX))*(self.view?.frame.height)! - (self.view?.frame.height)!/2
        let randomPosition = CGPoint(x: randomX, y: randomY)

        let shoeIndex = randomShoeGenerator?.nextInt()
        let shoeImgTitle = "yeezy\(shoeIndex!)"
        let shoeSpriteNode = SKSpriteNode(imageNamed: shoeImgTitle)
        shoeSpriteNode.setScale(0.1)
        shoeSpriteNode.position = randomPosition
        shoeSpriteNode.physicsBody = SKPhysicsBody(circleOfRadius: (shoeSpriteNode.size.width)/2)
        if shoeIndex! != 6 {
            shoeSpriteNode.physicsBody?.categoryBitMask = shoeCategory
        } else {
            shoeSpriteNode.physicsBody?.categoryBitMask = fakeShoeCategory
        }
        shoeSpriteNode.physicsBody?.contactTestBitMask = kanyeCategory | wallCategory
        shoeSpriteNode.physicsBody?.affectedByGravity = false
        shoeSpriteNode.run(moveAndRemove!)
        self.addChild(shoeSpriteNode)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == shoeCategory, secondBody.categoryBitMask == kanyeCategory {
            score += 1
            xFactor += 0.1
            yFactor += 0.1
            firstBody.node?.removeFromParent()
        }
        if firstBody.categoryBitMask == kanyeCategory, secondBody.categoryBitMask == shoeCategory {
            score += 1
            xFactor += 0.1
            yFactor += 0.1
            secondBody.node?.removeFromParent()
        }
        if firstBody.categoryBitMask == fakeShoeCategory, secondBody.categoryBitMask == kanyeCategory {
            gameOver = true
            if let del = gameDelegate {
                del.gameEnded()
            }
        }
        if firstBody.categoryBitMask == kanyeCategory, secondBody.categoryBitMask == fakeShoeCategory {
            gameOver = true
            if let del = gameDelegate {
                del.gameEnded()
            }
        }
        if firstBody.categoryBitMask == fakeShoeCategory, secondBody.categoryBitMask == wallCategory {
            firstBody.node?.removeFromParent()
        }
        if firstBody.categoryBitMask == shoeCategory, secondBody.categoryBitMask == wallCategory {
            firstBody.node?.removeFromParent()
        }
        if firstBody.categoryBitMask == wallCategory, secondBody.categoryBitMask == shoeCategory {
            secondBody.node?.removeFromParent()
        }
        if firstBody.categoryBitMask == wallCategory, secondBody.categoryBitMask == fakeShoeCategory {
            secondBody.node?.removeFromParent()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * xFactor, dy: accelerometerData.acceleration.y * yFactor)
        }
        if !gameOver {
            gameScore?.text = "Score: \(score)"
        } else {
            self.removeAllActions()
            self.removeAllChildren()
            shareButton = SKSpriteNode(imageNamed: "share")
            shareButton?.position = CGPoint(x:-(shareButton?.frame.width)!/2-CGFloat(10), y: 0)
            shareButton?.size = CGSize(width: (shareButton?.frame.width)!, height: (shareButton?.frame.height)!)
            self.addChild(shareButton!)
            restartButton = SKSpriteNode(imageNamed: "icon")
            restartButton?.position = CGPoint(x:CGFloat(10)+(restartButton?.frame.width)!/2, y:0)
            restartButton?.size = CGSize(width: (restartButton?.frame.width)!, height: (restartButton?.frame.height)!)
            self.addChild(restartButton!)
            gameOverLabel = SKLabelNode(fontNamed: "Avenir-Next")
            gameOverLabel?.text = "Game Over!"
            gameOverLabel?.position = CGPoint(x: 0, y: 80)
            gameOverLabel?.horizontalAlignmentMode = .center
            gameOverLabel?.fontSize = 30
            gameOverLabel?.fontColor = UIColor.black
            self.addChild(gameOverLabel!)
        }
        
    }
}
