//
//  NewNoteView.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 24/10/25.
//

import SwiftUI

struct NewNoteView: View {
	
	@Environment(\.dismiss) var dismiss
	
	@ObservedObject var notesViewModel: NotesViewModel
	
	@State var noteTitle: String = ""
	@State var noteBody: String = ""
	@State var noteColorString: String = ""
	@State var noteColor: Color = .white
	@State var noteTag: String = ""
	@State var noteDate: Date = Date.now
	
	@State var shouldPresentDismissAlert: Bool = false
	@Binding var shouldPresentSuccessHUD: Bool
	
	let tags: [String] = ["Dúvida", "Comentário", "Eureka", "Outros"]
	
	var body: some View {
		NavigationStack {
			Form {
				HStack {
					TextField("Título*", text: $noteTitle)
					
					Picker(selection: $noteTag) {
						ForEach(tags, id: \.self) { tag in
							Text(tag)
						}
					} label: {
						Text("Tag")
					}
					
				}
				
				ColorPicker("Cor da Anotação", selection: $noteColor)
					.onChange(of: noteColor) { oldValue, newValue in
						noteColorString = noteColor.toHexString()
					}
				TextEditor(text: $noteBody)
					.frame(height: 400)
					.navigationTitle("Nova Anotação")
					.toolbar {
						ToolbarItem(placement: .confirmationAction) {
							Button {
								let noteWrapper = NoteEntityWrapper(body: noteBody, colorString: noteColorString, date: Date.now, tag: noteTag, title: noteTitle)
								
								notesViewModel.createNote(using: noteWrapper)
								
								dismiss()
								
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
									withAnimation {
										shouldPresentSuccessHUD = true
									}
								}
								
								DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
									withAnimation {
										shouldPresentSuccessHUD = false
									}
								}
							} label: {
								Image(systemName: "checkmark")
							}
							.disabled(noteTitle.isEmpty || noteBody.isEmpty)
						}
						
						ToolbarItem(placement: .cancellationAction) {
							Button {
								shouldPresentDismissAlert.toggle()
							} label: {
								Image(systemName: "xmark")
							}
							.alert("Tem certeza que deseja sair?", isPresented: $shouldPresentDismissAlert) {
								Button("Sair", role: .destructive) { dismiss() }
							} message: {
								Text("Sua anotação será perdida!")
							}
						}
					}
			}
		}
		
	}
}

#Preview {
	NewNoteView(notesViewModel: NotesViewModel(), shouldPresentSuccessHUD: .constant(false))
}
