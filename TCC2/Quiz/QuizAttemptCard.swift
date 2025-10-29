//
//  QuizAttemptCard.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 29/10/25.
//

import SwiftUI
import CoreData

struct QuizAttemptCard: View {
	
	let attempt: QuizAttempt
	
	let dateFormatter: DateFormatter = {
		let f = DateFormatter()
		f.dateFormat = "dd/MM"
		return f
	}()
	
	var body: some View {
		NavigationLink {
			QuizAttemptDetailView(attempt: attempt)
		} label: {
			HStack {
				VStack(alignment: .leading) {
					
					Text(attempt.quiz?.title ?? "Quiz Title")
						.font(.title2)
					
					Text(String(format: "%.2f / 10", attempt.score))
						.foregroundStyle(attempt.score >= 6.0 ? .blue : .red)
				}
				
				Spacer()
				
				Text(dateFormatter.string(from: attempt.date ?? Date.now))
			}
			.padding()
			.background(
				RoundedRectangle(cornerRadius: 18)
					.foregroundStyle(.ultraThinMaterial)
			)
			.shadow(radius: 6)
		}
	}
}

#Preview {
	let attempt = QuizAttempt(context: DataController.shared.viewContext)
	QuizAttemptCard(attempt: attempt)
}
