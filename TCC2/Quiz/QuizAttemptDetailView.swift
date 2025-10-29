//
//  QuizAttemptDetailView.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 29/10/25.
//

import SwiftUI
import CoreData

struct QuizAttemptDetailView: View {
	
	let attempt: QuizAttempt
	
	let dateFormatter: DateFormatter = {
		let f = DateFormatter()
		f.dateFormat = "dd/MM"
		return f
	}()
	
	@State var responses: [Response] = []
	
	var body: some View {
		VStack {
			HStack {
				VStack(alignment: .leading) {
					
					Text(attempt.quiz?.title ?? "Quiz Title")
						.font(.title2)
						.bold()
					
					Text(String(format: "%.2f / 10", attempt.score))
						.foregroundStyle(attempt.score >= 6.0 ? .blue : .red)
				}
				
				Spacer()
				
				Text(dateFormatter.string(from: attempt.date ?? Date.now))
			}
			
			Spacer()
			
			
			ForEach(responses, id: \.id) { response in
				HStack {
					VStack {
						Text(response.question?.text ?? "Question Text")
						Text(response.answerChosen?.text ?? "Answer Text")
					}
					Spacer()
					Text(response.isCorrect ? "Acerto" : "Erro")
						.foregroundStyle(response.isCorrect ? .blue : .red)
				}
				Divider()
			}
			.onAppear {
				attempt.responses?.forEach { response in
					responses.append(response as! Response)
				}
			}
			
			Spacer()
		}
		.padding()
		.navigationTitle("Suas Respostas do Quiz")
	}
}

#Preview {
	let attempt = QuizAttempt(context: DataController.shared.viewContext)
	QuizAttemptDetailView(attempt: attempt)
}
