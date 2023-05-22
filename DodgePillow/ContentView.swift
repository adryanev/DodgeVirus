//
//  ContentView.swift
//  DodgePillow
//
//  Created by Adryan Eka Vandra on 22/05/23.
//

import SwiftUI
import SpriteKit
import CoreMotion
import GameKit
import CoreHaptics

class GamePlayScene: SKScene, SKPhysicsContactDelegate {
    
    private let motionManager = CMMotionManager()
    private lazy var haptic: CHHapticEngine? = {
       return try? CHHapticEngine()
    }()
    let background = SKSpriteNode(color: UIColor(named: "Color2")!, size: CGSize(width: ScreenSize.width, height: ScreenSize.heigth))
    
    lazy var player: SKShapeNode = {
        let circle = SKShapeNode(circleOfRadius: 40)
        circle.fillColor = UIColor(named: "Color4")!
        circle.name = "Player"
        circle.strokeColor = UIColor(named: "Color4")!
        return circle
    }()
    
    lazy var scoreLabel: SKLabelNode = {
        let label = SKLabelNode(attributedText: NSAttributedString(string: "0", attributes: [
            .font: UIFont.systemFont(ofSize: 48, weight: .medium),
            .foregroundColor: UIColor(named: "TitleColor")!]))
        
        return label
    }()
    
    lazy var obstacle: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "Pillow1")
        node.size = CGSize(width: 96, height: 80)

        return node
    }()
    
    var state: GameState = .paused
    var lastSpawnTime: Date?
    let gameStart: Date = .now
    var score: Int = 0
    var scoreTimer: Timer?
    var obstacleTimer: Timer?
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        motionManager.startAccelerometerUpdates()
        state = .played
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: view.frame)
        
        scene?.size = CGSize(width: ScreenSize.width, height: ScreenSize.heigth)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = 1
        
        addChild(background)
        initScore()
        initPlayer()
        generateObstacle()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA: SKPhysicsBody
        let contactB: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            contactA = contact.bodyA
            contactB = contact.bodyB
        }
        else {
            contactA = contact.bodyB
            contactB = contact.bodyA
        }
        
        print(contactA)
        print(contactB)
        
        if (contactA.categoryBitMask == CBitMask.player && contactB.categoryBitMask == CBitMask.obstacle) {
            
           gameOver()
        }
        if (contactA.categoryBitMask == CBitMask.obstacle && contactB.categoryBitMask == CBitMask.player) {
            gameOver()
        }
    }
    func initPlayer() {
        
        player.position = CGPoint(x: size.width / 2, y: size.height * 0.2)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.frame.size.width / 2)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.restitution = 0.2
        player.physicsBody?.categoryBitMask = CBitMask.player
        player.physicsBody?.contactTestBitMask = CBitMask.obstacle
        player.physicsBody?.collisionBitMask = CBitMask.obstacle
        player.zPosition = 5
        
        addChild(player)
    }
    
    func initScore() {
        
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.8)
        scoreLabel.zPosition =  10
        scoreTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateScore), userInfo: nil, repeats: true)
        
        addChild(scoreLabel)
    }
    
    @objc func updateScore() {
        score+=1
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager.accelerometerData {
            player.physicsBody?.applyImpulse(CGVector(dx: accelerometerData.acceleration.x * 9.8, dy: accelerometerData.acceleration.y * 9.8))
        }
        scoreLabel.attributedText = NSAttributedString(string: "\(score)", attributes: [
            .font: UIFont.systemFont(ofSize: 48, weight: .medium),
            .foregroundColor: UIColor(named: "TitleColor")!])
        
    }
    
    func generateObstacle() {
        obstacleTimer = .scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(generateObstacleObject), userInfo: nil, repeats: true)
    }
    
    @objc func generateObstacleObject() {
        let random = GKRandomDistribution(lowestValue: Int(ScreenSize.width * 0.2), highestValue: Int(ScreenSize.width * 0.8))
        obstacle = .init(imageNamed: "Pillow1")
        obstacle.name = "Obstacle"
        obstacle.position = CGPoint(x: random.nextInt() , y: Int(ScreenSize.heigth))
        obstacle.zPosition = 5
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.allowsRotation = false
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.physicsBody?.categoryBitMask = CBitMask.obstacle
        obstacle.physicsBody?.contactTestBitMask = CBitMask.player
        obstacle.physicsBody?.collisionBitMask = CBitMask.player
        addChild(obstacle)
        
        let moveAction  = SKAction.moveTo(y: 100, duration: 5)
//        let repeatAction = SKAction.repeatForever(moveAction)
        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction, deleteAction])
        obstacle.run(combine)
    }
    
    
    struct CBitMask {
        static let player: UInt32 = 0b1 // 1
        static let obstacle: UInt32 = 0b10 // 2
    }
    
    func gameOver() {
        obstacle.removeFromParent()
        player.removeFromParent()
        obstacleTimer?.invalidate()
        scoreTimer?.invalidate()
    }
    
}
struct ContentView: View {
    let mainMenu = GamePlayScene()
    var body: some View {
        SpriteView(scene: mainMenu, debugOptions: [.showsFPS, .showsNodeCount, .showsPhysics])
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum GameState {
    case played
    case paused
    case defeated
}
