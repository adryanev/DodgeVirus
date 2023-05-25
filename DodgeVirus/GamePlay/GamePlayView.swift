//
//  GameplayView.swift
//  DodgePillow
//
//  Created by Adryan Eka Vandra on 24/05/23.
//

import SwiftUI
import UIKit
import SpriteKit

struct GamePlayView: UIViewRepresentable {
	var size: CGSize
	var viewModel: GamePlayViewModel
	@Binding var isPaused: Bool

	func makeUIView(context: Context) -> SKView {
		let skView = SKView()
		skView.ignoresSiblingOrder = true
		let scene = GamePlayScene(viewModel: viewModel, size: size)
		skView.presentScene(scene)
		
		return skView
		
	}
	
	func updateUIView(_ uiView: SKView, context: Context) {
		// TODO every render swift ui
		uiView.isPaused = isPaused
	}
	
	typealias UIViewType = SKView
	
}
