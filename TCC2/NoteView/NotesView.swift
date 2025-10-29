//
//  NotesView.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 24/10/25.
//

import SwiftUI

struct NotesView: View {
	
	@ObservedObject var notesViewModel: NotesViewModel
	
	@State var newNoteViewIsPresented: Bool = false
	
	@State var shouldPresentSuccessHUD: Bool = false
	@State var noteFilter: String = "Todas"
	let noteTags: [String] = ["Todas", "Dúvida", "Comentário", "Eureka", "Outros"]
	
	let columns: [GridItem] = [
		.init(.adaptive(minimum: 100, maximum: 300), spacing: 20, alignment: .center),
			.init(.adaptive(minimum: 100, maximum: 300), spacing: 20, alignment: .center)
	]
	
	@State var filteredNotes: [NoteEntity] = []
	
	var body: some View {
		NavigationStack {
			Group {
				if !notesViewModel.notes.isEmpty {
					HStack {
						Spacer()
						Picker(selection: $noteFilter) {
							ForEach(noteTags, id: \.self) { tag in
								Text(tag).tag(tag)
							}
						} label: {
							Label("Filtrar por", systemImage: "line.3.horizontal.decrease")
						}
						.pickerStyle(.menu)
						.onChange(of: noteFilter) { oldValue, newValue in
							if newValue == "Todas" {
								filteredNotes = notesViewModel.notes
							} else {
								filteredNotes = notesViewModel.notes.filter { $0.tag == newValue }
							}
						}
					}
					ScrollView {
						LazyVGrid(columns: columns) {
							ForEach(filteredNotes) { note in
								NoteCard(note: note)
									.foregroundStyle(.black)
							}
						}
					}
					.padding(.horizontal)
				} else {
					Text("Nenhuma nota ainda")
						.foregroundStyle(.secondary)
				}
			}
			.navigationTitle("Suas Notas")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						newNoteViewIsPresented.toggle()
					} label: {
						Image(systemName: "plus")
					}
				}
			}
		}
		.overlay {
			if shouldPresentSuccessHUD {
				SuccessHUD(text: "Nota criada!")
					.onAppear {
						// iOS 16-: Feedback tátil via UIKit
						UIImpactFeedbackGenerator(style: .medium).impactOccurred()
					}
			}
		}
		.fullScreenCover(isPresented: $newNoteViewIsPresented) {
			NewNoteView(notesViewModel: notesViewModel, shouldPresentSuccessHUD: $shouldPresentSuccessHUD)
		}
		.onAppear {
			filteredNotes = notesViewModel.notes
		}
		.onChange(of: notesViewModel.notes) { oldValue, newValue in
			filteredNotes = newValue
			noteFilter = "Todas"
		}

	}
}

#Preview {
	NotesView(notesViewModel: NotesViewModel())
}
