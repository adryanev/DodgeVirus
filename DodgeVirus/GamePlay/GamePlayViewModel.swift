//
//  GameplayViewModel.swift
//  DodgePillow
//
//  Created by Adryan Eka Vandra on 24/05/23.
//

import SwiftUI
import AVFoundation

class GamePlayViewModel: ObservableObject {
	
	static let shared = GamePlayViewModel()
	
	
	init () {
		musicPlayer = {
			guard let url = Bundle.main.url(forResource: "BackgroundSound", withExtension: "mp3") else {
				return nil
			}
			
			let player = try? AVAudioPlayer(contentsOf: url)
			player?.numberOfLoops = -1
			return player
		}()
	}
	@Published private(set) var score: Int = 0
	@Published private(set) var gameState: GameState = GameState.initiated
	
	var musicPlayer: AVAudioPlayer?
	
	lazy var scoreTimer: Timer? = {
		return .scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateScore), userInfo: nil, repeats: true)
	}()
	
		
	@objc func updateScore(){
		self.score = self.score + 1
	}
	
	func pauseGame() {
		scoreTimer?.invalidate()
		musicPlayer?.pause()
		self.gameState = .paused
	}
	func resumeGame() {
		if !(scoreTimer?.isValid ?? true) {
			self.scoreTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateScore), userInfo: nil, repeats: true)
		}
		musicPlayer?.play()
		self.gameState = .played
	}
	
	func gameOver() {
		scoreTimer?.invalidate()
		musicPlayer?.stop()
		self.gameState = .defeated
	}
	
	func resetScore() {
		scoreTimer?.invalidate()
		musicPlayer?.stop()
		self.score = 0
		self.gameState = .initiated
	}
	
}

enum GameState {
	case played
	case paused
	case defeated
	case initiated
}
