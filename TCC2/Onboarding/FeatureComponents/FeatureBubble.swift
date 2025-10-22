//
//  FeatureBubble.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 21/10/25.
//

import SwiftUI

struct FeatureBubble: View {
	let text: String
	var isPrimary: Bool = false
	
	var body: some View {
		Text(text)
			.font(isPrimary ? .title.bold() : .headline)
			.multilineTextAlignment(.center)
			.padding(.horizontal, isPrimary ? 20 : 14)
			.padding(.vertical, isPrimary ? 18 : 10)
			.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: isPrimary ? 20 : 16, style: .continuous))
			.overlay {
				RoundedRectangle(cornerRadius: isPrimary ? 20 : 16, style: .continuous)
					.stroke(.white.opacity(0.15))
			}
			.shadow(color: .black.opacity(0.1), radius: isPrimary ? 12 : 8, x: 0, y: 4)
			.scaleEffect(isPrimary ? 1.0 : 0.98)
			.accessibilityAddTraits(isPrimary ? .isHeader : [])
	}
}

#Preview {
	FeatureBubble(text: "Visualizar Arquiteturas!", isPrimary: true)
}
