//
//  GraphUIState.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 27/10/25.
//

import Foundation
import SwiftUI
import Combine

enum ComponentRole: String, CaseIterable, Identifiable {
	case view = "View"
	case model = "Model"
	case viewModel = "ViewModel"
	case controller = "Controller"
	
	var id: String { rawValue }
}

struct NodeDescriptor: Identifiable, Equatable {
	let id = UUID()
	let role: ComponentRole
	let title: String
	let details: String
}

enum GraphIntent {
	case emitAction(from: ComponentRole)
	case highlight(role: ComponentRole)
	case clear
}


final class GraphUIState: ObservableObject {
	// Nó selecionado
	@Published var selected: NodeDescriptor? = nil
	
	@Published var pendingIntent: GraphIntent? = nil
}
