//
//  QuizView.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 29/10/25.
//

import SwiftUI
import CoreData

struct QuizView: View {
	
	@ObservedObject var quizViewModel: QuizViewModel
	
	let quiz: Quiz
	
	@State var attempts: [QuizAttempt] = []
	
	var body: some View {
		VStack {
			Text(quiz.title ?? "Quiz Title")
				.font(.title)
				.bold()
				.foregroundStyle(.accent)
			
			Button {
				
			} label: {
				Text("Começar Desafio!")
					.padding(.vertical, 20)
					.padding(.horizontal, 85)
					.background (
						RoundedRectangle(cornerRadius: 16)
							.fill(.ultraThinMaterial)
							.overlay(
								RoundedRectangle(cornerRadius: 16)
									.fill(.accent.opacity(0.2))  // só uma “tinta leve”
							)
					)
					.shadow(radius: 6)
			}
			.padding(.vertical, 30)
			
			Divider()
			
			ScrollView {
				if attempts.isEmpty {
					Text("Nenhuma tentativa ainda!")
						.font(.subheadline)
						.bold()
						.foregroundStyle(.secondary)
						.padding(.vertical, 30)
				} else {
					ForEach(attempts) { attempt in
						QuizAttemptCard(attempt: attempt)
					}
				}
			}
			.onAppear {
				quiz.attempts?.forEach { attempt in
					attempts.append(attempt as! QuizAttempt)
				}
			}
			
		}
	}
}

#Preview {
	Button {
		
	} label: {
		Text("Começar Desafio!")
			.padding(.vertical, 20)
			.padding(.horizontal, 85)
			.background (
				RoundedRectangle(cornerRadius: 16)
					.fill(.ultraThinMaterial)
					.overlay(
						RoundedRectangle(cornerRadius: 16)
							.fill(.accent.opacity(0.2))  // só uma “tinta leve”
					)
			)
			.shadow(radius: 6)
	}
	.padding(.vertical, 30)
	.border(.red)
}
