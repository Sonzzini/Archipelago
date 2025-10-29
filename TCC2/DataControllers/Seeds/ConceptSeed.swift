//
//  ConceptSeed.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 29/10/25.
//

import Foundation
import CoreData

extension DataController {
	
	func trySeedConcepts() -> Result<[Concept], Error> {
		let request = NSFetchRequest<Concept>(entityName: "Concept")
		
		do {
			let result = try viewContext.fetch(request)
			
			if result.isEmpty {
				let seedResult = seedConcepts()
				switch seedResult {
				case .success(let concepts):
					return .success(concepts)
				case .failure(let error):
					return .failure(error)
				}
			}
			
			return .success(result)
		} catch {
			return .failure(error)
		}
	}
	
	private func seedConcepts() -> Result<[Concept], Error> {
		let concept1 = Concept(context: viewContext)
		concept1.name = "Swift"
		
		let concept2 = Concept(context: viewContext)
		concept2.name = "iOS"
		
		let concept3 = Concept(context: viewContext)
		concept3.name = "macOS"
		
		do {
			try viewContext.save()
			return .success([concept1, concept2, concept3])
		} catch {
			return .failure(error)
		}
	}
	
}
