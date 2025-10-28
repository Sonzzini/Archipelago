//
//  ColorExtension.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 24/10/25.
//

import Foundation
import SwiftUI

extension Color {
	
	func toHexString() -> String {
		let uiColor = UIColor(self)
		
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 0
		
		uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
		
		let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
		return String(format: "#%06x", rgb)
	}
	
}
