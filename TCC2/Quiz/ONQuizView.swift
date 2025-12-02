//
//  ONQuizView.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 29/10/25.
//

import SwiftUI

struct ONQuizView: View {
	
	@Environment(\.dismiss) var dismiss
	
	@ObservedObject var quizViewModel: QuizViewModel
	
	let quiz: Quiz
	
	@State var shouldPresentSuccessHUD: Bool = false
	@State var showXP: Bool = false
	
	var body: some View {
		if quizViewModel.hasNextQuestion {
			VStack {
				Text("Pergunta \(quizViewModel.currentQuestionIndex + 1)")
					.font(.title2.weight(.semibold))
				
				Text(quizViewModel.currentQuestionText())
					.font(.system(size: 32, weight: .bold))
					.multilineTextAlignment(.center)
					.minimumScaleFactor(0.6)
					.padding(.horizontal, 24)
					.frame(maxHeight: 250, alignment: .center)
				
				Spacer(minLength: 8)
				
				LazyVGrid(columns: [.init(.flexible(), spacing: 24),
										  .init(.flexible(), spacing: 24)]) {
											  ForEach(quizViewModel.currentQuestionOptions()) { option in
												  Button {
													  withAnimation(.easeInOut(duration: 0.3)) {
														  quizViewModel.registerResponse(for: option)
														  quizViewModel.nextQuestion()
													  }
												  } label: {
													  Text(option.text ?? "Opção")
														  .padding()
														  .frame(minWidth: 100, idealWidth: UIScreen.main.bounds.width/2 - 48, maxWidth: UIScreen.main.bounds.width/2, minHeight: 100, idealHeight: UIScreen.main.bounds.width/2 - 48, maxHeight: UIScreen.main.bounds.width/2)
														  .background(
															RoundedRectangle(cornerRadius: 16)
																.fill(.ultraThinMaterial)
														  )
														  .padding(.horizontal)
												  }
											  }
										  }
			}
			.onAppear {
				quizViewModel.startQuiz()
			}
			.navigationBarBackButtonHidden()
			
			
			
		} else {
			VStack {
				
				Text("Suas respostas")
					.font(.largeTitle)
					.bold()
				
				ScrollView {
					ForEach(Array(quizViewModel.results), id: \.key) { question, answer in
						VStack(alignment: .leading, spacing: 8) {
							Text(question.text ?? "Pergunta")
								.font(.headline)
							HStack {
								Text("Resposta: \(answer.0.text ?? "/" )")
									.font(.subheadline)
									.foregroundStyle(.secondary)
								
								if answer.0.isCorrect {
									Image(systemName: "checkmark")
										.foregroundStyle(.green)
										.bold()
								} else {
									Image(systemName: "xmark")
										.foregroundStyle(.red)
								}
								
							}
							HStack {
								Text("Tempo: \(String(format: "%.2f", answer.1))s")
								Spacer()
								Text("Confiança: \(quizViewModel.calculateConfianca(with: answer.1))")
							}
							.font(.subheadline)
							.foregroundStyle(.secondary)
							
						}
						.padding()
						.frame(maxWidth: .infinity, alignment: .leading)
						.background(
							RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial)
						)
						.padding(.horizontal)
						Divider()
					}
				}
				
				Divider()
				
				Text("Score: \(String(format: "%.2f", quizViewModel.calculateScore()))/100")
					.bold()
				
				Text("Tempo Total: \(String(format: "%.2f", quizViewModel.calculateQuizzTime()))s")
				
				Button {
					
					dismiss()
					quizViewModel.registerQuizzAttempt()
					quizViewModel.reset()
					
				} label: {
					Text("Terminar Desafio")
						.font(.title2)
						.padding()
				}
				.buttonStyle(.glassProminent)
			}
			.onAppear {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
					withAnimation {
						shouldPresentSuccessHUD = true
					}
				}
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
					withAnimation {
						shouldPresentSuccessHUD = false
						showXP = true
					}
				}
			}
			.overlay {
				if shouldPresentSuccessHUD {
					SuccessHUD(text: "Desafio Concluído!")
						.onAppear {
							// iOS 16-: Feedback tátil via UIKit
							UIImpactFeedbackGenerator(style: .medium).impactOccurred()
						}
				}
				if showXP {
					
//					ExperienceGainView(initialLevel: , initialXP: <#T##Double#>, gainedXP: <#T##Double#>, onDismiss: <#T##() -> Void#>)
				}
			}
			.navigationBarBackButtonHidden()
		}
//		.onAppear {
//			quizViewModel.startQuiz(quiz: quiz)
//		}
	}
}
