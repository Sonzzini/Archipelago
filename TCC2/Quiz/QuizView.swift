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
	
	var body: some View {
		VStack {
			Text(quiz.title ?? "Quiz Title")
				.font(.title)
				.bold()
				.foregroundStyle(.accent)
			
			NavigationLink {
				// Começar o desafio
				ONQuizView(quizViewModel: quizViewModel, quiz: quiz)
					
			} label: {
				Text("Começar Desafio!")
					.padding(.vertical, 20)
					.padding(.horizontal, 85)
					.background (
						RoundedRectangle(cornerRadius: 16)
							.fill(.ultraThinMaterial)
							.overlay(
								RoundedRectangle(cornerRadius: 16)
									.fill(.accent.opacity(0.2))
							)
					)
					.shadow(radius: 6)
			}
			.padding(.vertical, 30)
			
			Divider()
			
			ScrollView {
				if quizViewModel.attemptsForQuiz(quiz: quiz).isEmpty {
					Text("Nenhuma tentativa ainda!")
						.font(.subheadline)
						.bold()
						.foregroundStyle(.secondary)
						.padding(.vertical, 30)
				} else {
					ForEach(quizViewModel.attemptsForQuiz(quiz: quiz)) { attempt in
						QuizAttemptCard(attempt: attempt)
							.padding(.horizontal)
					}
					.padding(.top)
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
							.fill(.accent.opacity(0.2))
					)
			)
			.shadow(radius: 6)
	}
	.padding(.vertical, 30)
	.border(.red)
}
