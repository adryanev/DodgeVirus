//
//  ContentView.swift
//  DodgePillow
//
//  Created by Adryan Eka Vandra on 22/05/23.
//

import SwiftUI

struct GamePlayPage: View {
	@State var isPaused = false
	@ObservedObject var viewModel: GamePlayViewModel
	@State var backToMainMenu: Bool = false
	@Environment(\.dismiss) var dismiss

	
    var body: some View {
		NavigationView {
			ZStack {
				GeometryReader { value in
					GamePlayView(size: value.size, viewModel: viewModel, isPaused: Binding<Bool>(get: {
						viewModel.gameState != GameState.played
					}, set: { value, _ in
						isPaused = value
					}))
				}
				
				VStack {
					Text("\(viewModel.score)")
						.font(Font(UIFont.systemFont(ofSize: 48, weight: .medium)))
						.padding(EdgeInsets(top: 72, leading: 32, bottom: 32, trailing: 32))
						.foregroundColor(Color("TitleColor"))
					Spacer()
				}
				VStack {
					HStack(alignment: .top) {
						Spacer()
						Button {
							viewModel.pauseGame()
							isPaused.toggle()
						} label: {
						Image(systemName: "pause.rectangle")
								.resizable()
								.frame(width: 32, height: 24)
								.foregroundColor(Color("Color3"))
							
							.padding(EdgeInsets(top: 64, leading: 32, bottom: 32, trailing: 32))
							
						}
					}
					Spacer()
				}

			}.customDialog(isShowing: Binding<Bool>(get: {
				viewModel.gameState != GameState.played
			}, set: { value, _ in
				isPaused = value
			})){
				if viewModel.gameState == GameState.paused {
					PauseView().environmentObject(viewModel)
				}
				if viewModel.gameState == GameState.defeated {
					GameOverView(backToMainMenu: $backToMainMenu).environmentObject(viewModel)
				}
				
			}
			
		.ignoresSafeArea()
		}
		.onChange(of: backToMainMenu) { value in
			if value {
				dismiss()
			}
		}
       
    }
}

struct GamePlayPage_Previews: PreviewProvider {
    static var previews: some View {
        GamePlayPage(viewModel: GamePlayViewModel())
    }
}

struct PauseView: View {
	@EnvironmentObject var viewModel: GamePlayViewModel
	var body: some View {
		VStack(spacing: 32) {
			Text("Paused".uppercased())
				.font(Font(UIFont.systemFont(ofSize: 36, weight: .semibold, width: .expanded)))
				.foregroundColor(Color("OnPrimary"))
				.padding(.bottom, 32)
			
			Button {
				viewModel.resumeGame()
			} label: {
				Text("Resume".uppercased())
					.font(Font(UIFont.systemFont(ofSize: 36, weight: .semibold, width: .expanded)))
					.frame(maxWidth: .infinity)
				
					.padding()
				
			}
			.background(Color("Color3"))
			.foregroundColor(Color("OnPrimary"))
			.clipShape(Capsule())
			Button {
				viewModel.gameOver()
			} label: {
				Text("Quit".uppercased())
					.font(Font(UIFont.systemFont(ofSize: 36, weight: .semibold, width: .expanded)))
					.frame(maxWidth: .infinity)
				
					.padding()
			}
			.background(Color("Color3"))
			.foregroundColor(Color("OnPrimary"))
			.clipShape(Capsule())
		}
		.padding(40)
	}
}

struct GameOverView: View {
	@EnvironmentObject var viewModel: GamePlayViewModel
	@Binding var backToMainMenu: Bool
	var body: some View {
		VStack(spacing: 32) {
			Text("Game Over".uppercased())
				.font(Font(UIFont.systemFont(ofSize: 36, weight: .semibold, width: .expanded)))
				.foregroundColor(Color("OnPrimary"))
				.padding(.bottom, 32)
			
			Text("Your Score".uppercased())
				.font(Font(UIFont.systemFont(ofSize: 24, weight: .semibold, width: .expanded)))
				.foregroundColor(Color("OnPrimary"))
			
			Text("\(viewModel.score)")
				.font(Font(UIFont.systemFont(ofSize: 28, weight: .semibold, width: .expanded)))
				.foregroundColor(Color("OnPrimary"))
				.padding(.bottom, 32)
			
			Button {
				viewModel.resetScore()
				backToMainMenu.toggle()
			} label: {
				Text("Quit".uppercased())
					.font(Font(UIFont.systemFont(ofSize: 36, weight: .semibold, width: .expanded)))
					.frame(maxWidth: .infinity)
				
					.padding()
			}
			.background(Color("Color3"))
			.foregroundColor(Color("OnPrimary"))
			.clipShape(Capsule())
		}
		.padding(40)
	}
}
