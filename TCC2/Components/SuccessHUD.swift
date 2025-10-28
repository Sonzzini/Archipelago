//
//  SuccessHUD.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 24/10/25.
//

import SwiftUI

struct SuccessHUD: View {
	var text: String = "Sucesso!"
	
	var body: some View {
		VStack(spacing: 8) {
			Image(systemName: "checkmark.circle.fill")
				.font(.system(size: 44, weight: .semibold))
				.foregroundStyle(.green)
				.symbolRenderingMode(.hierarchical)
			
			Text(text)
				.font(.headline)
		}
		.padding(.horizontal, 20)
		.padding(.vertical, 14)
		.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
		.shadow(radius: 8)
		.transition(.scale.combined(with: .opacity))
	}
}

#Preview {
	SuccessHUD()
}
