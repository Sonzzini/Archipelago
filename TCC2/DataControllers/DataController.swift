//
//  DataController.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 19/10/25.
//

import Foundation
import CoreData

final class DataControllerSource {
	
	static let shared = DataControllerSource()
	
	let persistentContainer: NSPersistentContainer
	
	var viewContext: NSManagedObjectContext {
		return persistentContainer.viewContext
	}
	
	var modelDataController: DataControllerProtocol? = nil
	
	private init() {
		persistentContainer = NSPersistentContainer(name: "Model")
		
		persistentContainer.loadPersistentStores { (description, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
	}
	
	func saveContext() -> Result<Void, Error> {
		do {
			try viewContext.save()
			return .success(Void())
		} catch {
			return .failure(error)
		}
	}
	
	
	
}

protocol DataControllerProtocol {
	associatedtype Entity: NSManagedObject
	
	func save(_ configure: (Entity) -> Void) throws -> Entity
	func delete(_ obj: Entity) throws
	func fetchAll(predicate: NSPredicate?, sort: [NSSortDescriptor]) throws -> [Entity]
	func fetchOne(by id: NSManagedObjectID) throws -> Entity
}
