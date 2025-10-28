//
//  NoteDetailView.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 25/10/25.
//

import SwiftUI
import CoreData

struct NoteDetailView: View {
	
	let note: NoteEntity
	@State var noteBody: String = ""
	
	let dateFormatter: DateFormatter = {
		let f = DateFormatter()
		f.dateFormat = "dd/MM"
		return f
	}()
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				HStack {
					Circle()
						.frame(height: 25)
						.foregroundStyle(note.colorString?.stringHexToColor() ?? .blue)
					
					Text(note.title ?? "Note Title")
						.font(.title)
					
					Spacer()
					
					Text(dateFormatter.string(from: note.date ?? Date.now))
						.font(.title2)
				}
				Text(note.tag ?? "Note Tag")
					.foregroundStyle(.secondary)
			}
			.padding(.horizontal)
			
			Divider()
			
			TextEditor(text: $noteBody)
				.frame(height: .infinity)
		}
		.onAppear { noteBody = note.body ?? "" }
	}
}

#Preview {
	let note = NoteEntity(context: DataController.shared.viewContext)
	
	NoteDetailView(note: note)
}
