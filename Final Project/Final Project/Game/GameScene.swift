//
//  GameScene.swift
//  Final Project
//
//  Created by Dave & Muchlas BFF on 4/30/20.
//  Copyright © 2020 Dave & Muchlas BFF. All rights reserved.
//

/* Notes
 
 CGSize measures in pixels not points:
 Size for a Iphone 11 Pro Max:
 Pixel:
 1242 X 2688
 
 CGPoint:
 414 X 896
 
 
 Size for a Iphones 7
 CGPoint:
 375 x 667
 */

/* Copy Right:
 Player Sprite (Space Ship): https://www.pngitem.com/middle/Tohwmx_transparent-sprite-spaceship-transparent-png-rocket-ship-sprite/
        Image License: Personal Use Only
 
 Bullet Sprite:
    https://www.pikpng.com/pngvi/hhJxhow_cannonball-cannon-ball-pixel-art-clipart/
        Image License: Personal Use Only
 */

/* Task List By Saturday 11:59 PM
 - Merge Highscore Implementation and Logic (coordination with sklabel)
 - - Implement Highscore variable and how that will tie into everything
 - Refine Physicsbody collision boundaries
 - Make the highscore label cleaner and not clipping through the edge of the screen
 - Make bullet and asteroid collision physics more consistant
 - Emitters on collisions
 - - asteroid -> spaceship (not game over) : spark emitter (shield being damaged)
 - - projectile -> asteroid : Maybe some kind of force wave
 */

/* Extra task lists
 - Switching database to use userdefault
 - App Icon
 - Being able to type in name for highscore
 */

/* Stretch Tasks
 - Need to swivel rocket when user starts touch -> Fires when user ends touch
 - - Thus can make it so that user can glide finger across screen and ship will follow it.
 - Smooth out player controls
 - - Undestand better how accelerometer works the way it does.
 - Smooth out asteroid implementation
 - Shield displacement emitter when hit
 */

/* Cool Gameplay Mechanics
 - Shields (instead of lives)
 - - Shield bar at bottom left of screen under spaceship
 - Spaceship floating and slowly spinning accross game over screen
 - Collectables
 - - Score bonus
 - - Time Stop?
 - - Rapid Fire?
 - - Shield Restore
 - - Lazer (Immediately destroys asteroids)
 */

/* Debug
 - Bullets sometimes go faster than anticipated
 - Game still running in background
 */

/* Code for rotating by degrees instead of radians
 extension CGFloat {
     func degreesToRadians() -> CGFloat {
         return self * CGFloat.pi / 180
     }
 }

 let rabbitTexture = SKTexture(imageNamed: "rabbit.png")

 let spriteNode = SKSpriteNode(texture: rabbitTexture)

 spriteNode.zRotation = CGFloat(30).degreesToRadians()
 */

import SpriteKit
import GameplayKit
import SwiftUI
import CoreMotion

// The bitmask categories for physics bodies so you
//  can tell what is what
struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let player   : UInt32 = 0b01       // 1
    static let projectile: UInt32 = 0b10      // 2
    static let asteroid: UInt32 = 0b11       // 3
    static let border: UInt32 = 0b100       // 4
}

// CGPoint operations.
func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
  func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
  }
#endif

extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  
  func normalized() -> CGPoint {
    return self / length()
  }
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    // Player Fields
    var player:SKSpriteNode!
    var isPlayerAlive = true
    var shields = 2
    
    // Score Fields
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // Difficulty Properties
    // Increases by 1 whenever
    var difficulty = 1
    // The amount of points the player needs to get to get to the next difficulty level
    let diffScale = 60
    // How much the speed of the asteroid increases every difficulty level.
        // Only increments if difficulty level is odd
    let asteroidSpeedIncrease = -50
    // How many asteroids are added to the wave max each difficulty level
        // Only increments if difficulty level is even
    let asteroidCountIncrease = 1
    
    // Asteroid fields
    var maxAsteroidSpeed:CGFloat = -300
    // Max number of asteroids in a wave. Increases as difficulty increases
    var maxAsteroids = 5
    
    // Bullet Fields
    var bulletSpeed:CGFloat = 1000
    // Keeps track of when the bullet was last fired.
    //  For implementing the logic that there is a reload interval
    var lastFire:Int?
    let reloadTime = 1
    
    // Timer counter for the game
    var timeCounter = 0
    
    // Fields for handling Accelerometer data which is interpreted as player controls
    let motionManager = CMMotionManager()
    var yTurn:CGFloat = 0 // Measures the turn of the device.
    
    
            // Game Properties ---------------------------------------------------
    
    // First function to be called when the scene is loaded
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        createLevel()
        
        // Should be what pushes the meteors, etc. downward.
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9)
        self.physicsWorld.contactDelegate = self
    }
    
    // Creates the physics boundary of the level, the background, the label, and the player
    private func createLevel() {
        // Boundary (border) of the game
        let border = UIBezierPath()
        border.move(to: CGPoint(x: 0, y: self.frame.height + 2000))
        border.addLine(to: CGPoint(x: 0, y: -1000))
        border.addLine(to: CGPoint(x: self.frame.width, y: -1000))
        border.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height + 1000))
        border.close()
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: border.cgPath)
        self.physicsBody?.categoryBitMask = PhysicsCategory.border
        
        // Background which is just an emitternode
        if let background = SKEmitterNode(fileNamed: "StarBackground") {
            background.name = "background"
            background.position = CGPoint(x: frame.midX, y: frame.height)
            background.zPosition = -1;
            background.advanceSimulationTime(30)
            
            addChild(background)
        } else {
            print("Background Didn't load")
        }
        
        // Score Label
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: frame.width * 0.8, y: frame.height * 0.9)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = UIColor.white
        score = 0
        addChild(scoreLabel)
    
        // Player Sprite (which is made from a spaceship png)
        let playerTexture = SKTexture(imageNamed: "spaceship")
        player = SKSpriteNode(texture: playerTexture)
        player.size = CGSize(width: 60, height: 60)
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.position = CGPoint(x: frame.width/2, y: frame.height * 0.1)
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: player.size)//SKPhysicsBody(circleOfRadius: max(player.size.width / 3, player.size.height / 3))
        player.physicsBody?.isDynamic = false // Not affected by forces and gravity, etc
        player.physicsBody?.categoryBitMask = PhysicsCategory.player // What is the nodes physics category
        player.physicsBody?.collisionBitMask = PhysicsCategory.asteroid // What can it collide with physically
        // What does it touch to trigger a contact event
        player.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
        addChild(player)
        
        // Starts collecting Accelerometer data
        motionManager.startAccelerometerUpdates()
        
        // Starts game time
        startTime()
    }
    
    // Game Time Implementation
    func startTime() {
        let wait = SKAction.wait(forDuration: 1) //change countdown speed here
        let block = SKAction.run({ [unowned self] in
            self.timeCounter += 1
            self.score += 1
        })
        let sequence = SKAction.sequence([wait,block])

        run(SKAction.repeatForever(sequence), withKey: "countdown")
    }
    
    // End game
    func endGame() {
        print("Game over Man")
        
        //Death sound
        let deathSound = SKAction.playSoundFileNamed("death.mp3", waitForCompletion: false)
        player.run(deathSound)
        
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size, score: self.score, view: self.scene?.view)
        view?.presentScene(gameOverScene, transition: reveal)
    }
    
    // Aight, we gonna go with the accelerometer for right now.
    //  Cause it does more of what I want it to do than the gyroscope
    override func update(_ currentTime: TimeInterval) {
        // Updates game difficulty by increasing asteroid speed and count
        if score >= difficulty * diffScale {
            if difficulty % 2 == 0 {
                maxAsteroids += asteroidCountIncrease
            } else {
                maxAsteroidSpeed += CGFloat(difficulty * asteroidSpeedIncrease)
            }
            difficulty += 1
        }
        
        // Logic for player movement in concordance with accelerometer data
        if let accelData = motionManager.accelerometerData {
            // Stops player at the edges of the screen
            let speed = CGFloat(30.0)
            // How far away the anchor point of the sprite is from the edges
            let space = CGFloat(30.0)
            // Right boundary. (Left is just 40)
            let right = self.size.width - space
            
            if player.position.x + CGFloat(accelData.acceleration.x) * speed < space {
                player.position.x = space
            }
            else if player.position.x + CGFloat(accelData.acceleration.x) * speed > right {
                player.position.x = right
            }
            else {
                player.position.x += CGFloat(accelData.acceleration.x) * speed
            }
        }
        
                // Asteroid Properties ----------------------------------------
        // Gets rid of the asteroids that are below the player
        for child in children {
            if child.frame.maxY < 0 {
                if !frame.intersects(child.frame) {
                    child.removeFromParent()
                }
            }
            
            if child.name == "asteroid" {
                // Max speed of the asteroids
                if let v = child.physicsBody?.velocity.dy {
                    if v < CGFloat(maxAsteroidSpeed) {
                        child.physicsBody?.velocity.dy = CGFloat(maxAsteroidSpeed)
                    }
                }
            } else if child.name == "projectile" {
                if child.frame.maxY > frame.height {
                    if !frame.intersects(child.frame) {
                        child.removeFromParent()
                    }
                }
            } else if child.name == "shieldDampening" {
                child.position = player.position
                print("I'm moving")
            }
        }
        
        // Adds all the asteroids to an array and then checks if that array is empty or not
        let asteroidCount = children.compactMap { $0 as? Asteroid }
        
        if asteroidCount.isEmpty {
            createWave()
        }
    }
    
            // Asteroid Properties ---------------------------------------------------------------
    
    // Creates waves of asteroids
    func createWave() {
        guard isPlayerAlive else { return }
        
        for _ in 0..<maxAsteroids {
            // Size of the asteroid
            let sSize = CGSize(width: 100, height: 100)
            // Accounts for the size of the asteroid and makes it so that it doesn't spawn within the edge of the frame.
            //  Which is a physics body.
            let spawnBoundary = (sSize.width / 2) + 5
            // Generate a random number for the starting x position of the ateroid
            let rand = Float.random(in: 0...1000)
            // Makes it so that the asteroid only appears within the width of the frame
            let denom = Float(size.width - spawnBoundary)
            // Starting positions of the asteroids
                //The .rmainder function is basically just mod for floats
            let startX = CGFloat(Float(spawnBoundary) + rand.remainder(dividingBy: denom))
            let startY = frame.maxY
            let startPos = CGPoint(x: CGFloat(startX), y: CGFloat(startY))
            // How far above the screen that the asteroid starts
            let startOffset = 100 * CGFloat(Float.random(in: 0.0...15.0))
            
            let newAsteroid = Asteroid(health: 1, startPosition: startPos, yOffset: startOffset, startSize: sSize, maxSpeed: maxAsteroidSpeed)
            addChild(newAsteroid)
        }
    }
    
            // Firing Properties ------------------------------------
    
    // Executes when the user lifts off from the screen after tapping
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        fireBullet(touchLocation: touchLocation)
    }
    
    // Player can only fire a bullet every 1 seconds
    func fireBullet(touchLocation: CGPoint) {
        // Limit firing intervals
        if lastFire != nil {
            if timeCounter - lastFire! >= reloadTime {
                bang(touchLocation: touchLocation)
                lastFire = timeCounter
            }
        } else {
            bang(touchLocation: touchLocation)
            lastFire = timeCounter
        }
    }
    
    // Actually applies the physics and sets everything up for the bullet
    func bang(touchLocation: CGPoint) {
        // Makes sure the player isn't firing behind the
        //  spaceship
        let startPos = CGPoint(x: player.position.x, y: player.position.y + player.size.height/2)
        
        let offset = touchLocation - startPos
        
        if offset.y < 0 {return}
        
        let bullet = Projectile(startPos: startPos)
        addChild(bullet)
        
        //Fire Laser sound
        let laserAction = SKAction.playSoundFileNamed("laser.wav", waitForCompletion: false)
        player.run(laserAction)
        
        let direction  = offset.normalized()
        
        let shootAmount = direction * bulletSpeed
        
        let realDest = shootAmount + bullet.position
        let realVector = CGVector(dx: realDest.x, dy: realDest.y)
        print(realVector)
        
        bullet.physicsBody?.applyForce(realVector)
    }
    
            // Collission Properties --------------------------------------
    
    func bulletDidCollideWithAsteroid(projectile: SKSpriteNode, asteroid: SKSpriteNode) {
        projectile.removeFromParent()
    }
    
    func asteroidDidCollideWithPlayer(player: SKSpriteNode, asteroid: SKSpriteNode) {
        asteroid.removeFromParent()
    }
    
    // Is called whenever there is a contact event between two physics bodies
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        // Gives you an idea of which body is which cause they arent passed
        //  in any particular order.
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if(firstBody.categoryBitMask ^ PhysicsCategory.projectile == 0) {
            if(secondBody.categoryBitMask ^ PhysicsCategory.asteroid == 0) {
                if let projectile = firstBody.node as? SKSpriteNode, let asteroid = secondBody.node as? SKSpriteNode {
                    bulletDidCollideWithAsteroid(projectile: projectile, asteroid: asteroid)
                }
            }
        } else if (firstBody.categoryBitMask ^ PhysicsCategory.player == 0) {
            if(secondBody.categoryBitMask ^ PhysicsCategory.asteroid == 0) {
                
                //Damage sound
                let damageSound = SKAction.playSoundFileNamed("damage.wav", waitForCompletion: false)
                player.run(damageSound)
                
                if shields > 0 {
                    shields -= 1
                    if let player = firstBody.node as? SKSpriteNode, let asteroid = secondBody.node as? SKSpriteNode {
                        asteroidDidCollideWithPlayer(player: player, asteroid: asteroid)
                        if let spark = SKEmitterNode(fileNamed: "ShieldDampening") {
                             spark.name = "shieldDamepening"
                             spark.position = CGPoint(x: player.position.x, y: player.position.y)
                             spark.zPosition = 1;
                            
                             addChild(spark)
                             
                             let wait = SKAction.wait(forDuration: 0.5)
                             let delete = SKAction.removeFromParent()
                             let sequence = SKAction.sequence([wait,delete])

                             run(sequence)
                             
                        } else {
                             print("Background Didn't load")
                        }
                    }
                } else {
                    isPlayerAlive = false
                    endGame()
                }
            }
        }
    }
}
