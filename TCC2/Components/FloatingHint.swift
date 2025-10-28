//
//  FloatingHint.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 28/10/25.
//

import SwiftUI

struct FloatingHint: View {
	
	let text: String
	
	init(_ text: String) {
		self.text = text
	}
	
	var body: some View {
		Text(text)
			.padding(13)
			.background(
				RoundedRectangle(cornerRadius: 15)
					.foregroundStyle(.ultraThinMaterial)
			)
	}
}

#Preview {
	FloatingHint("Hello!")
}
