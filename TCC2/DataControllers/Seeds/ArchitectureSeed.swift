//
//  ArchitectureSeed.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 29/10/25.
//

import Foundation
import CoreData

extension DataController {
	
	func trySeedArchitectures() -> Result<[Architecture], Error> {
		let request = NSFetchRequest<Architecture>(entityName: "Architecture")
		
		do {
			let result = try viewContext.fetch(request)
			
			if result.isEmpty {
				let seedResult = seedArchitectures()
				
				switch seedResult {
				case .success(let architectures):
					return .success(architectures)
				case .failure(let error):
					return .failure(error)
				}
			}
			
			return .success(result)
		} catch {
			return .failure(error)
		}
	}
	
	private func seedArchitectures() -> Result<[Architecture], Error> {
		let mvvm = Architecture(context: viewContext)
		mvvm.name = "MVVM"
		
		let mvc = Architecture(context: viewContext)
		mvc.name = "MVC"
		
		let viper = Architecture(context: viewContext)
		viper.name = "Viper"
		
		let geral = Architecture(context: viewContext)
		geral.name = "Geral"
		
		do {
			try viewContext.save()
			return .success([mvvm, mvc, viper, geral])
		} catch {
			return .failure(error)
		}
	}
}
