//
//  ExperienceGainView.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 07/11/25.
//

import SwiftUI

struct ExperienceGainView: View {
	
	let initialLevel: Int
	let initialXP: Double
	let gainedXP: Double
	let onDismiss: () -> Void
	
	var body: some View {
		ExperienceGainContentView(
						initialLevel: initialLevel,
						initialXP: initialXP,
						gainedXP: gainedXP,
						onDismiss: onDismiss
				  )
	}
	
}

#Preview {
	ExperienceGainView(
		initialLevel: 5,
		initialXP: 40,
		gainedXP: 100,
		onDismiss: {
			
		}
	)
}
