//
//  MainMenuScene.swift
//  DodgePillow
//
//  Created by Adryan Eka Vandra on 22/05/23.
//

import SpriteKit

class MainMenuScene: SKScene {

    
    let background = SKSpriteNode(color: UIColor(named: "Color2")!, size: CGSize(width: ScreenSize.width, height: ScreenSize.heigth))
    lazy var gameTitle: SKLabelNode = {
        let label = SKLabelNode(attributedText: NSAttributedString(
            string: "Dodge Pillow", attributes: [
                .font: UIFont.systemFont(ofSize: 48, weight: .bold, width: .expanded),
                .foregroundColor: UIColor(named: "TitleColor")!]
        ));
        return label
    }()
    
    override func didMove(to view: SKView) {
        scene?.size = CGSize(width: ScreenSize.width, height: ScreenSize.heigth)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = 1
        
        gameTitle.zPosition = 10
        gameTitle.position = CGPoint(x: size.width / 2, y: size.height * 0.667)
//        gameTitle.color = UIColor(named: "Color3")
        addChild(background)
        addChild(gameTitle)
    }
}

