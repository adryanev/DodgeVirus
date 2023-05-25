//
//  MainMenuScene.swift
//  DodgePillow
//
//  Created by Adryan Eka Vandra on 22/05/23.
//

import SpriteKit
import GameKit

class MainMenuScene: SKScene {

    
	lazy var obstacle: SKSpriteNode = {
		let node = SKSpriteNode(imageNamed: "Virus")
		node.size = CGSize(width: 96, height: 80)
		
		return node
	}()
	var obstacleTimer: Timer?

    override func didMove(to view: SKView) {
		scene?.backgroundColor = .clear
		view.allowsTransparency = true
		view.backgroundColor = .clear
		scene?.size = CGSize(width: ScreenSize.width, height: ScreenSize.heigth)
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
		addChild(obstacle)
		
		let moveAction  = SKAction.moveTo(y: 10, duration: 5)
		let deleteAction = SKAction.removeFromParent()
		let combine = SKAction.sequence([moveAction, deleteAction])
		obstacle.run(combine)
	}
	
}

