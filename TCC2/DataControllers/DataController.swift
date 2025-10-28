//
//  DataController.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 19/10/25.
//

import Foundation
import CoreData

final class DataController {
	
	static let shared = DataController()
	
	let persistentContainer: NSPersistentContainer
	
	var viewContext: NSManagedObjectContext {
		return persistentContainer.viewContext
	}
	
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
	
	func profileIsSetup() -> Bool {
		let request = NSFetchRequest<ProfileEntity>(entityName: "ProfileEntity")
		
		do {
			let result = try viewContext.fetch(request)
			if result.isEmpty {
				let profile = ProfileEntity(context: viewContext)
				profile.isFirstLogin = true
				profile.experience = 0
				profile.level = 1
				
				try viewContext.save()
				return true
			} else {
				print("DATACONTROLLER.profileSetup(): Profile already exists, should not create another one")
				return result.first!.isFirstLogin
			}
		} catch {
			print("DATACONTROLLER.profileSetup(): Error setting up ProfileEntity: \(error)")
			return true
		}
	}
	
	func finishProfileSetup(with name: String) {
		let request = NSFetchRequest<ProfileEntity>(entityName: "ProfileEntity")
		
		do {
			let result = try viewContext.fetch(request)
			if let profile = result.first, result.count == 1 {
				profile.isFirstLogin = false
				profile.name = name
				
				try viewContext.save()
			} else {
				print("DATACONTROLLER.finishProfileSetup: Could not find profile to update")
			}
		} catch {
			print("DATACONTROLLER.finishProfileSetup: Error finishing setup on ProfileEntity: \(error)")
		}
	}
	
	func fetchProfile() -> Result<ProfileEntity, Error> {
		let request = NSFetchRequest<ProfileEntity>(entityName: "ProfileEntity")
		
		do {
			let result = try viewContext.fetch(request)
			if let profile = result.first, result.count == 1 {
				return .success(profile)
			} else {
				return .failure(NSError(domain: "Profile not found", code: 0, userInfo: nil))
			}
		} catch {
			return .failure(error)
		}
	}
	
	func deleteProfile() -> Result<String, Error> {
		let result = self.fetchProfile()
		
		switch result {
		case .success(let profile):
			let name = profile.name ?? "Unknown Name"
			
			do {
				viewContext.delete(profile)
				
				try viewContext.save()
				
				return .success(name)
			} catch {
				return .failure(error)
			}
			
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func editProfile(with newName: String) -> Result<ProfileEntity, Error> {
		let result = self.fetchProfile()
		
		switch result {
		case .success(let profile):
			profile.name = newName
			
			do {
				try viewContext.save()
				
				return .success(profile)
			} catch {
				return .failure(error)
			}
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func fetchNotes() -> Result<[NoteEntity], Error> {
		let request = NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
		
		do {
			let result = try viewContext.fetch(request)
			
			return .success(result)
		} catch {
			return .failure(error)
		}
	}
	
	func createNote(using wrapper: NoteEntityWrapper) -> Result<NoteEntity, Error> {
		let note = NoteEntity(context: viewContext)
		note.title = wrapper.title
		note.body = wrapper.body
		note.date = wrapper.date
		note.tag = wrapper.tag
		note.colorString = wrapper.colorString
		
		do {
			try viewContext.save()
			
			return .success(note)
		} catch {
			return .failure(error)
		}
	}
}

//protocol DataControllerProtocol {
//	associatedtype Entity: NSManagedObject
//	
//	func save(_ configure: (Entity) -> Void) throws -> Entity
//	func delete(_ obj: Entity) throws
//	func fetchAll(predicate: NSPredicate?, sort: [NSSortDescriptor]) throws -> [Entity]
//	func fetchOne(by id: NSManagedObjectID) throws -> Entity
//}
