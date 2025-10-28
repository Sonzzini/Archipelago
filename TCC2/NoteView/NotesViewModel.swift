//
//  NotesViewModel.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 24/10/25.
//

import Foundation
import SwiftUI
import Combine

class NotesViewModel: ObservableObject {
	
	@Published var notes: [NoteEntity] = []
	@Published var errorMessage: String? = nil
	
	init() {
		self.fetchNotes()
	}
	
	func fetchNotes() {
		let result = DataController.shared.fetchNotes()
		
		switch result {
		case .success(let notes):
			self.notes = notes
		case .failure(let error):
			self.errorMessage = "Error fetching notes: \(error.localizedDescription)"
		}
	}
	
	func createNote(using wrapper: NoteEntityWrapper) {
		let result = DataController.shared.createNote(using: wrapper)
		
		switch result {
		case .success(let note):
			self.notes.append(note)
		case .failure(let error):
			self.errorMessage = "Error creating note: \(error.localizedDescription)"
		}
	}
	
}
