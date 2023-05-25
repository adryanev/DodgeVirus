//
//  MainPage.swift
//  DodgePillow
//
//  Created by Adryan Eka Vandra on 25/05/23.
//

import SwiftUI
import SpriteKit

struct MainPage: View {
	@State var showAttribution: Bool = false
	@State var navigateToGame = false
    var body: some View {
		NavigationView{
			ZStack {
				
				// replace with pillow fall animation
				SpriteView(scene: MainMenuScene(), options: [.allowsTransparency])
				
				
				VStack(spacing: 32) {
					Spacer()
					Text("Dodge\nVirus!")
						.multilineTextAlignment(.center)
						.font(Font(UIFont.systemFont(ofSize: 72, weight: .semibold, width: .expanded)))
						.foregroundColor(Color("TitleColor"))
					
					Spacer()
					
					NavigationLink (destination:
						GamePlayPage(viewModel: GamePlayViewModel.shared)
						.navigationBarHidden(true), isActive: $navigateToGame)
					{
						Button {
							navigateToGame.toggle()
						} label: {
							HStack {
								Image(systemName: "play.fill").resizable().frame(width: 36, height: 36)
								Text("Play".uppercased())
									.font(Font(UIFont.systemFont(ofSize: 36, weight: .semibold, width: .expanded)))
								
							}
							.frame(maxWidth: .infinity)
							.padding()
							
						}
						.background(Color("Color1"))
						.foregroundColor(Color("OnPrimary"))
						.clipShape(Capsule())
						.padding()
					}
					
				
					Button {
						showAttribution.toggle()
					} label: {
						HStack {
							Image(systemName: "c.circle.fill").resizable().frame(width: 36, height: 36)
							Text("Attribution".uppercased())
								.font(Font(UIFont.systemFont(ofSize: 24, weight: .semibold, width: .expanded)))
							
						}
						.frame(maxWidth: .infinity)
						.padding()
					}
					.background(Color("Color1"))
					.foregroundColor(Color("OnPrimary"))
					.clipShape(Capsule())
					.padding()
					
					Spacer()
				}
				
				
			}
			.padding()
			.ignoresSafeArea()
			.background(Color("Color2"))
			.customDialog(isShowing: $showAttribution){
				AttributionView(showAttribution: $showAttribution)
				
			}
		}

    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}

struct AttributionView: View {
	@Binding var showAttribution:Bool
	
	var body: some View {
		VStack(spacing: 32) {
			Text("Attribution".uppercased())
				.font(Font(UIFont.systemFont(ofSize: 28, weight: .semibold, width: .expanded)))
				.foregroundColor(Color("OnPrimary"))
			
			VStack(alignment: .leading) {
				
				Link(destination: URL(string: "https://www.freepik.com/free-vector/flat-virus-collection_7274169.htm#query=corona%20virus%20flat&position=41&from_view=search&track=ais")!) {
					Text("Virus: Freepik")
						.font(Font(UIFont.systemFont(ofSize: 24, weight: .regular)))
						.foregroundColor(Color("OnPrimary"))
				}
				
				Link(destination: URL(string: "https://www.freepik.com/free-vector/how-wear-face-mask-illustration_10320187.htm#query=head%20with%20mask%20flat&position=21&from_view=search&track=ais")!) {
					Text("Head: Freepik")
						.font(Font(UIFont.systemFont(ofSize: 24, weight: .regular)))
						.foregroundColor(Color("OnPrimary"))
				}
				
				Link(destination: URL(string: "https://pixabay.com/users/lesiakower-25701529/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=150573")!) {
					Text("Music: Lesiakower")
						.font(Font(UIFont.systemFont(ofSize: 24, weight: .regular)))
						.foregroundColor(Color("OnPrimary"))
				}
				
			}
						

			Button {
				showAttribution.toggle()
			} label: {
				Text("Close".uppercased())
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
