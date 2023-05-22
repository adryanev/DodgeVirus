//
//  Extensions.swift
//  DodgePillow
//
//  Created by Adryan Eka Vandra on 22/05/23.
//

import UIKit

struct ScreenSize {
  static let width = UIScreen.main.bounds.size.width
  static let heigth = UIScreen.main.bounds.size.height
  static let maxLength = max(ScreenSize.width, ScreenSize.heigth)
  static let minLength = min(ScreenSize.width, ScreenSize.heigth)
}
