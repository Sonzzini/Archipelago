//
//  NodePopup.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 27/10/25.
//

import SwiftUI

struct NodePopup: View {
	
	let node: NodeDescriptor
	let send: (GraphIntent) -> Void
	
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		NavigationStack {
			VStack(alignment: .leading, spacing: 16) {
				Text(node.title)
					.font(.title2).bold()
				Text(node.details)
					.foregroundStyle(.secondary)
				
				Divider()
				
				// Exemplo de ações
				Button {
					send(.emitAction(from: node.role))
				} label: {
					Label("Emitir ação a partir de \(node.role.rawValue)", systemImage: "paperplane.fill")
				}
				.buttonStyle(.borderedProminent)
				
				Button {
					send(.highlight(role: node.role))
				} label: {
					Label("Destacar nó", systemImage: "sparkles")
				}
				
				Spacer()
			}
			.padding()
			.navigationTitle("Detalhes do Nó")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Fechar") {
						send(.clear) // opcional
						dismiss()
					}
				}
			}
		}
		
	}
}

