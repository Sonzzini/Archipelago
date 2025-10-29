//
//  ONQuizView.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 29/10/25.
//

import SwiftUI

struct ONQuizView: View {
	
	let quiz: Quiz
	
	@State var questions: [Question] = []
	@State var currentQuestionOptions: [AnswerOption] = []
	
	@State var index: Int = 0
	@State var selections: [Int: AnswerOption] = [:]
	
	private var currentQuestion: Question { questions[index] }
	private var isFirst: Bool { index == 0 }
	private var isLast: Bool { index == quiz.questions?.count ?? 1 - 1 }
	private var currentSelection: AnswerOption? { selections[index] }
	
	var body: some View {
		VStack {
			Text("Pergunta \(index + 1)")
				.font(.title2.weight(.semibold))
			
			Text(currentQuestion.text ?? "Question")
				.font(.system(size: 42, weight: .bold))
				.multilineTextAlignment(.center)
				.minimumScaleFactor(0.6)
				.padding(.horizontal, 24)
				.frame(maxHeight: 250, alignment: .center)
			
			Spacer(minLength: 8)
			
			LazyVGrid(columns: [.init(.flexible(), spacing: 24),
									  .init(.flexible(), spacing: 24)]) {
										  ForEach(currentQuestionOptions) { option in
											  
										  }
									  }
		}
		.onAppear {
			quiz.questions?.forEach { question in
				questions.append(question as! Question)
			}
			currentQuestion.options?.forEach { option in
				currentQuestionOptions.append(option as! AnswerOption)
			}
		}
		.onChange(of: currentQuestion) { oldValue, newValue in
			currentQuestionOptions = []
			newValue.options?.forEach { option in
				currentQuestionOptions.append(option as! AnswerOption)
			}
		}
	}
}
