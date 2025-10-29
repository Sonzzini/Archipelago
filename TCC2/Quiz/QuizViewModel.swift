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
	
}
