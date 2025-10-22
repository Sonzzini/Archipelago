//
//  ProfileDataController.swift -> DataRepository
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 19/10/25.
//

import Foundation
import CoreData

class DataRepository<Entity: NSManagedObject>: DataControllerProtocol {
	
	private let context: NSManagedObjectContext
	
	init(context: NSManagedObjectContext = DataControllerSource.shared.viewContext) {
		self.context = context
	}
	
	@discardableResult
	func save(_ configure: (Entity) -> Void) throws -> Entity {
		let obj = Entity(context: context)
		configure(obj)
		try context.save()
		return obj
	}
	
	func delete(_ obj: Entity) throws {
		context.delete(obj)
		try context.save()
	}
	
	func fetchAll(predicate: NSPredicate? = nil, sort: [NSSortDescriptor] = []) throws -> [Entity] {
		let request = Entity.fetchRequest()
		request.predicate = predicate
		request.sortDescriptors = sort
		guard let result = try context.fetch(request) as? [Entity] else {
			return []
		}
		return result
	}
	
	func fetchOne(by id: NSManagedObjectID) throws -> Entity {
		guard let obj = try context.existingObject(with: id) as? Entity else {
			throw NSError(domain: "Repo", code: 404, userInfo: [NSLocalizedDescriptionKey: "Object not found"])
		}
		return obj
	}
	
	
}
