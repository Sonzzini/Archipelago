//
//  QuizViewModel.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 29/10/25.
//

import Foundation
import SwiftUI
import Combine


class QuizViewModel: ObservableObject {
	
	@Published var quizzes: [Quiz] = []
	@Published var currentQuestionIndex: Int = 0
	@Published var quizSelectionID: Quiz.ID? = nil
	@Published var errorMessage: String? = nil
	@Published var hasNextQuestion: Bool = true
	
	@Published var results: [Question: (AnswerOption, Double)] = [:]
	
	@Published var attempts: [QuizAttempt] = []
	
	var quizzStartDate: Date? = nil
	
	var currentQuestionStartDate: Date? = nil
	
	var confiancas: [Int] = []
	
	init() {
		seedMVVMQuizzes()
		seedMVCQuizzes()
		seedVIPERQuizzes()
	}
	
	private func seedMVVMQuizzes() {
		let result = DataController.shared.trySeedMVVMQuizzes()
		
		switch result {
		case .success(let quizzes):
			self.quizzes = quizzes
		case .failure(let error):
			self.errorMessage = "Could not load quizzes: \(error.localizedDescription)"
		}
	}
	
	private func seedMVCQuizzes() {
		
	}
	
	private func seedVIPERQuizzes() {
		
	}
	
	func startQuiz() {
		self.quizzStartDate = Date.now
		self.currentQuestionStartDate = Date.now
		
	}
	
	func endQuiz() {
		
		let timeTaken = Date.now.timeIntervalSince(quizzStartDate ?? Date.now)
		
	}
	
	func currentQuiz() -> Quiz {
		return quizzes[0]
	}
	
	func currentQuizQuestions() -> [Question] {
		var allQuestions: [Question] = []
		
		quizzes[0].questions?.forEach { question in
			allQuestions.append(question as! Question)
		}
		
		return allQuestions
	}
	
	func currentQuestion() -> Question {
		return currentQuizQuestions()[currentQuestionIndex]
	}
	
	func currentQuestionText() -> String {
		var allQuestions: [Question] = []
		
		quizzes[0].questions?.forEach { question in
			allQuestions.append(question as! Question)
		}
		
		return allQuestions[currentQuestionIndex].text ?? "Unknown Question Text"
	}
	
	func currentQuestionOptions() -> [AnswerOption] {
		var allQuestions: [Question] = []
		
		quizzes[0].questions?.forEach { question in
			allQuestions.append(question as! Question)
		}
		
		var allOptions: [AnswerOption] = []
		allQuestions[currentQuestionIndex].options?.forEach { option in
			allOptions.append(option as! AnswerOption)
		}
		
		return allOptions
	}
	
	func nextQuestion() {
		if currentQuestionIndex < (quizzes[0].questions?.count ?? 0) - 1 {
			self.currentQuestionIndex += 1
			
			self.currentQuestionStartDate = Date.now
			
		} else {
			hasNextQuestion = false
		}
	}
	
	func registerResponse(for option: AnswerOption) {
		self.results[currentQuestion()] = (option, calculateQuestionTime())
	}
	
	func calculateQuestionTime() -> Double {
		let timeTaken: TimeInterval = Date.now.timeIntervalSince(currentQuestionStartDate ?? Date.now)
		return timeTaken
	}
	
	func calculateQuizzTime() -> Double {
		guard let startDate = quizzStartDate else { return 0 }
		
		let timeTaken: TimeInterval = Date.now.timeIntervalSince(startDate)
		return timeTaken
	}
	
	func calculateScore() -> Double {
		let questionCount = currentQuizQuestions().count
		let correctAnswersCount = results.values.filter { $0.0.isCorrect }.count
		
		return (Double(correctAnswersCount) / Double(questionCount)) * 100
	}
	
	func calculateConfianca(with time: TimeInterval) -> Int {
		/*
		 0s-10s -> Confiança 5
						Altíssimo nível
		 
		 10s-15s -> Confiança 4
						Alto nível
		 
		 15s-20s -> Confiança 3
						Médio nível
		 
		 20s-25s -> Confiança 2
						Baixo nível
		 
		 25s-... -> Confiança 1
						Baixíssimo nível
		 */
		switch time {
		case 0..<10:
			self.confiancas.append(5)
			return 5
		case 10..<15:
			self.confiancas.append(4)
			return 4
		case 15..<20:
			self.confiancas.append(3)
			return 3
		case 20..<25:
			self.confiancas.append(2)
			return 2
		default:
			self.confiancas.append(1)
			return 1
		}
	}
	
	func registerQuizzAttempt() {
		let result = DataController.shared.registerQuizzAttempt(
			with: results,
			score: calculateScore(),
			confiancas: confiancas,
			for: currentQuiz()
		)
		
		switch result {
		case .success(let attempt):
			self.attempts.append(attempt)
		case .failure(let error):
			self.errorMessage = "Could not register attempt: \(error)"
		}
		
		DataController.shared.award(levels: 0, experience: Int(calculateScore()))
	}
	
	func attemptsForQuiz(quiz: Quiz) -> [QuizAttempt] {
		var attempts: [QuizAttempt] = []
		quiz.attempts?.forEach { attempt in
			attempts.append(attempt as! QuizAttempt)
		}
		return attempts
	}
	
	func reset() {
		self.confiancas = []
		self.currentQuestionIndex = 0
		self.hasNextQuestion = true
		self.results = [:]
		self.quizzStartDate = nil
		self.currentQuestionStartDate = nil
	}
}
