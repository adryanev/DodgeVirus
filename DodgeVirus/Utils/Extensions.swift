//
//  Extensions.swift
//  DodgePillow
//
//  Created by Adryan Eka Vandra on 22/05/23.
//

import UIKit
import SwiftUI

struct ScreenSize {
  static let width = UIScreen.main.bounds.size.width
  static let heigth = UIScreen.main.bounds.size.height
  static let maxLength = max(ScreenSize.width, ScreenSize.heigth)
  static let minLength = min(ScreenSize.width, ScreenSize.heigth)
}

struct CustomDialog<DialogContent: View>: ViewModifier {
	
	@Binding var isShowing: Bool // set this to show/hide the dialog
	let dialogContent: DialogContent
	
	init(isShowing: Binding<Bool>, @ViewBuilder dialogContent: () -> DialogContent) {
		_isShowing = isShowing
		self.dialogContent = dialogContent()
	}
	
	func body(content: Content) -> some View {
		// wrap the view being modified in a ZStack and render dialog on top of it
		ZStack {
			content
			if isShowing {
				// the semi-transparent overlay
				Rectangle().foregroundColor(Color.black.opacity(0.6))
				// the dialog content is in a ZStack to pad it from the edges
				// of the screen
				ZStack {
					dialogContent
						.background(
							RoundedRectangle(cornerRadius: 10)
								.foregroundColor(Color("Color1")))
				}.padding()
			}
		}
		.ignoresSafeArea()
	}
}

extension View {
	func customDialog<DialogContent: View>(
		isShowing: Binding<Bool>,
		@ViewBuilder dialogContent: @escaping () -> DialogContent
	) -> some View {
		self.modifier(CustomDialog(isShowing: isShowing, dialogContent: dialogContent))
	}
}
