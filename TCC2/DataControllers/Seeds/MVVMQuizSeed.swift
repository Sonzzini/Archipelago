//
//  MVVMQuizzes.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 29/10/25.
//

import Foundation
import CoreData

extension DataController {
	
	func trySeedMVVMQuizzes() -> Result<[Quiz], Error> {
		let request = NSFetchRequest<Quiz>(entityName: "Quiz")
		
		do {
			let result = try viewContext.fetch(request)
			
			if result.isEmpty { // TODO: Mudar, já que terá quiz de VIPER e MVC também...
				let mvvmBasicsSeedResult = seedMVVMBasics()
				
				var allMVVMSeeds: [Quiz] = []
				
				switch mvvmBasicsSeedResult {
				case .success(let quiz):
					allMVVMSeeds.append(quiz)
				case .failure(let error):
					return .failure(error)
				}
				
				return .success(allMVVMSeeds)
				
			}
			
			return .success(result)
		} catch {
			return .failure(error)
		}
	}
	
	private func seedMVVMBasics() -> Result<Quiz, Error> {
		let quiz = Quiz(context: viewContext)
		quiz.title = "MVVM Basics"
		
		// MARK: - QUESTION 1
		let question1 = Question(context: viewContext)
		question1.text = "No MVVM, quem recebe a intenção do usuário (toque) e inicia o processamento?"
		
		let option1_1 = AnswerOption(context: viewContext)
		let option1_2 = AnswerOption(context: viewContext)
		let option1_3 = AnswerOption(context: viewContext)
		let option1_4 = AnswerOption(context: viewContext)
		
		option1_1.text = "Model" ; option1_1.isCorrect = false
		option1_2.text = "View" ; option1_2.isCorrect = false
		option1_3.text = "ViewModel" ; option1_3.isCorrect = true
		option1_4.text = "Repository" ; option1_4.isCorrect = false
		
		// Colocando todas as opções na pergunta 1
		[option1_1, option1_2, option1_3, option1_4].forEach { option in
			option.question = question1
			question1.addToOptions(option)
		}
		
		// MARK: - QUESTION 2
		let question2 = Question(context: viewContext)
		question2.text = "Em MVVM, o estado para a UI deve ser exposto por onde?"
		
		let option1_2_1 = AnswerOption(context: viewContext)
		let option1_2_2 = AnswerOption(context: viewContext)
		let option1_2_3 = AnswerOption(context: viewContext)
		let option1_2_4 = AnswerOption(context: viewContext)
		
		option1_2_1.text = "ViewModel (bindings/observables)" ; option1_2_1.isCorrect = true
		option1_2_2.text = "Model (variáveis)" ; option1_2_2.isCorrect = false
		option1_2_3.text = "View (state e bindings)" ; option1_2_3.isCorrect = false
		option1_2_4.text = "Router (published properties)" ; option1_2_4.isCorrect = false
		
		[option1_2_1, option1_2_2, option1_2_3, option1_2_4].forEach { option in
			option.question = question2
			question2.addToOptions(option)
		}
		
		// MARK: - QUESTION 3
		let question3 = Question(context: viewContext)
		question3.text = "No MVVM, colocar acesso a rede direto no Model é:"
		
		let option1_3_1 = AnswerOption(context: viewContext)
		let option1_3_2 = AnswerOption(context: viewContext)
		let option1_3_3 = AnswerOption(context: viewContext)
		let option1_3_4 = AnswerOption(context: viewContext)
		
		option1_3_1.text = "Aceitável (faz sentido)" ; option1_3_1.isCorrect = false
		option1_3_2.text = "Preferível no ViewModel" ; option1_3_2.isCorrect = false
		option1_3_3.text = "Preferível em serviços/repositórios" ; option1_3_3.isCorrect = true
		option1_3_4.text = "Obrigatório na View" ; option1_3_4.isCorrect = false
		
		[option1_3_1, option1_3_2, option1_3_3, option1_3_4].forEach { option in
			option.question = question3
			question3.addToOptions(option)
		}
		
		// MARK: - Colocando todas as perguntas no quiz
		[question1, question2, question3].forEach { question in
			quiz.addToQuestions(question)
			question.quiz = quiz
		}
		
		do {
			try viewContext.save()
			return .success(quiz)
		} catch {
			return .failure(error)
		}
	}
	
}
