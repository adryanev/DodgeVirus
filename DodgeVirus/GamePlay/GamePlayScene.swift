//
//  GamePlayScene.swift
//  DodgePillow
//
//  Created by Adryan Eka Vandra on 22/05/23.
//

import SpriteKit
import CoreMotion
import GameKit
import CoreHaptics

class GamePlayScene: SKScene, SKPhysicsContactDelegate {
	
	private let viewModel: GamePlayViewModel
	init(viewModel: GamePlayViewModel, size: CGSize) {
		self.viewModel = viewModel
		super.init(size: size)

	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("Unimplemented")
	}
	private let motionManager = CMMotionManager()
	private lazy var haptic: CHHapticEngine? = {
		return try? CHHapticEngine()
	}()
	let background = SKSpriteNode(color: UIColor(named: "Color2")!, size: CGSize(width: ScreenSize.width, height: ScreenSize.heigth))
	
	lazy var player: SKSpriteNode = {
		let head = SKSpriteNode(imageNamed: "Head")
		head.name = "Player"
		return head
	}()
	
	
	lazy var obstacle: SKSpriteNode = {
		let node = SKSpriteNode(imageNamed: "Virus")
		node.size = CGSize(width: 96, height: 80)
		
		return node
	}()
	
	let motionQueue = OperationQueue()
	var obstacleTimer: Timer?
	
	lazy var worldCollisionSound: SKAction =  {
		let audio = SKAction.playSoundFileNamed("WorldCollision", waitForCompletion: false)
		return audio
	}()
	
	lazy var obstacleCollisionSound: SKAction = {
		let audio = SKAction.playSoundFileNamed("VirusCollision", waitForCompletion: false)
		return audio
	}()
	
	
	override func didMove(to view: SKView) {
		viewModel.resumeGame()
		let frame = scene?.frame
		self.physicsWorld.contactDelegate = self
		motionManager.startAccelerometerUpdates()
		self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame! )
		self.physicsBody?.categoryBitMask = CBitMask.world
		player.physicsBody?.contactTestBitMask = CBitMask.player
		player.physicsBody?.collisionBitMask = CBitMask.player
		
		scene?.size = CGSize(width: ScreenSize.width, height: ScreenSize.heigth)
		background.position = CGPoint(x: size.width / 2, y: size.height / 2)
		background.zPosition = 1
		
		addChild(background)
		
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
		
		if (contactA.categoryBitMask == CBitMask.player && contactB.categoryBitMask == CBitMask.world) {
			
			playHaptic(0.5, 0.5)
			run(worldCollisionSound)
		}
		
		if (contactA.categoryBitMask == CBitMask.player && contactB.categoryBitMask == CBitMask.obstacle) {
			
			playHaptic(1, 1)
			run(obstacleCollisionSound)
			gameOver()
			
		}
		if (contactA.categoryBitMask == CBitMask.obstacle && contactB.categoryBitMask == CBitMask.player) {
			playHaptic(1, 1)
			run(obstacleCollisionSound)
			gameOver()
			
		}
		
	}
	
	func playHaptic(_ intent: Float, _ sharp: Float ) {
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
		
		let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: intent)
		let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharp)
		let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
		
		do {
			let pattern = try CHHapticPattern(events: [event], parameters: [])
			let player = try haptic?.makePlayer(with: pattern)
			try haptic?.start()
			try player?.start(atTime: 0)
		} catch {
			print("Failed to play pattern: \(error.localizedDescription).")
		}
	}
	
	func initPlayer() {
		
		player.position = CGPoint(x: size.width / 2, y: size.height * 0.2)
		player.physicsBody = SKPhysicsBody(circleOfRadius: player.frame.size.width / 2)
		player.physicsBody?.isDynamic = true
		player.physicsBody?.affectedByGravity = false
		player.physicsBody?.allowsRotation = true
		player.physicsBody?.restitution = 0.5
		player.physicsBody?.categoryBitMask = CBitMask.player
		player.physicsBody?.contactTestBitMask = CBitMask.obstacle | CBitMask.world
		player.physicsBody?.collisionBitMask = CBitMask.obstacle | CBitMask.world
		player.zPosition = 5
		
		addChild(player)
	}
	
	
	@objc func updateScore() {
		if !(self.view?.isPaused ?? false) {
			viewModel.updateScore()
			
		}
		
	}
	
	override func update(_ currentTime: TimeInterval) {
		if let accelerometerData = motionManager.accelerometerData {
			player.physicsBody?.applyImpulse(CGVector(dx: accelerometerData.acceleration.x * 9.8, dy: accelerometerData.acceleration.y * 9.8))
		}
	}
	
	func generateObstacle() {
		obstacleTimer = .scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(generateObstacleObject), userInfo: nil, repeats: true)
	}
	
	@objc func generateObstacleObject() {
		if (self.view?.isPaused ?? true) {
			return
		}
		let random = GKRandomDistribution(lowestValue: Int(ScreenSize.width * 0.1), highestValue: Int(ScreenSize.width * 0.9))
		obstacle = .init(imageNamed: "Virus")
		obstacle.name = "Obstacle"
		obstacle.position = CGPoint(x: random.nextInt() , y: Int((view?.frame.height ?? ScreenSize.heigth)))
		obstacle.zPosition = 5
		obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
		obstacle.physicsBody?.allowsRotation = false
		obstacle.physicsBody?.affectedByGravity = false
		obstacle.physicsBody?.categoryBitMask = CBitMask.obstacle
		obstacle.physicsBody?.contactTestBitMask = CBitMask.player
		obstacle.physicsBody?.collisionBitMask = CBitMask.player
		addChild(obstacle)
		
		let moveAction  = SKAction.moveTo(y: 10, duration: 5)
		let deleteAction = SKAction.removeFromParent()
		let combine = SKAction.sequence([moveAction, deleteAction])
		obstacle.run(combine)
	}
	
	
	struct CBitMask {
		static let player: UInt32 = 0b1 // 1
		static let obstacle: UInt32 = 0b10 // 2
		static let world: UInt32 = 0b100 //4
	}
	func gameOver() {
		obstacle.removeFromParent()
		player.removeFromParent()
		obstacleTimer?.invalidate()
		obstacleTimer = nil
		viewModel.gameOver()
		
	}
	
}
