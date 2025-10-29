//
//  NoteCard.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 24/10/25.
//

import SwiftUI
import CoreData

struct NoteCard: View {
	
	let note: NoteEntity
	
	let dateFormatter: DateFormatter = {
		let d = DateFormatter()
		d.dateFormat = "dd/MM"
		return d
	}()
	
	var body: some View {
		NavigationLink {
			NoteDetailView(note: note)
		} label: {
			VStack {
				Text("\(note.title ?? "Note Title")")
					.font(.title3)
				Text("\(note.tag ?? "Note Tag")")
					.foregroundStyle(.secondary)
				Text("\(dateFormatter.string(from: note.date ?? Date.now))")
					.foregroundStyle(.secondary)
			}
			.frame(minWidth: 150, idealWidth: 180, maxWidth: 300, minHeight: 150, idealHeight: 180, maxHeight: 300)
			
//			.glassEffect()
			.background(
				note.colorString?.stringHexToColor()
					.clipShape(RoundedRectangle(cornerRadius: 16))
			)
			.shadow(radius: 6)
		}

		
	}
	
}

#Preview {
	let note = NoteEntity(context: DataController.shared.viewContext)
	
	NoteCard(note: note)
}
