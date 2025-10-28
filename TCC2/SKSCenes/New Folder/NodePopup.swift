//
//  NodePopup.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 27/10/25.
//

import SwiftUI

struct NodePopup: View {
	
	let node: IslandNode
	let onEmit: () -> Void
	
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(alignment: .leading, spacing: 16) {
					Text(node.type.rawValue)
						.font(.title2).bold()
					Text(node.type.description)
						.foregroundStyle(.secondary)
					
					Divider()
					
					// Exemplo de ações
					Button {
						onEmit()
						dismiss()
					} label: {
						switch node.type {
						case .view:
							viewLabel
						case .model:
							modelLabel
						case .viewModel:
							viewModelLabel
						default:
							Label("uhhh", systemImage: "paperplane.fill")
						}
					}
					.buttonStyle(.borderedProminent)
					
//					Button {
//						
//					} label: {
//						Label("Destacar nó", systemImage: "sparkles")
//					}
					
					Spacer()
				}
			}
			.padding()
			.navigationTitle("Detalhes do Nó")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Fechar") {
						dismiss()
					}
				}
			}
		}
		
	}
}

extension NodePopup {
	
	private var viewLabel: some View {
		Label("Salvar novo modelo a partir da View", systemImage: "paperplane.fill")
	}
	
	private var modelLabel: some View {
		Label("Salvar novo modelo a partir do Model", systemImage: "paperplane.fill")
	}
	
	private var viewModelLabel: some View {
		Label("Salvar novo modelo a partir do ViewModel", systemImage: "paperplane.fill")
	}
}
