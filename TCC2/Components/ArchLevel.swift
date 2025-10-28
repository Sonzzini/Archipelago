//
//  ArchLevel.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 28/10/25.
//

import Foundation
import SwiftUI


struct ArchLevel: Identifiable, Hashable {
	let id = UUID()
	let title: String
	let subtitle: String
}

struct ArchitectureLevelCard: View {
	let title: String
	let subtitle: String
	var body: some View {
		VStack {
			Text(title)
				.font(.title2)
				.bold()
			Text(subtitle)
				.foregroundStyle(.secondary)
		}
		.frame(width: 280, height: 180)
		.background(.thinMaterial)
		.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
	}
}

