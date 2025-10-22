//
//  ProfileViewModel.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 22/10/25.
//

import Foundation
import SwiftUI
import Combine


class ProfileViewModel: ObservableObject {
	
	@Published var profile: ProfileEntity?
	@Published var errorMessage: String?
	
	let repo: DataRepository<ProfileEntity>
	
	init() {
		self.repo = DataRepository<ProfileEntity>()
		getProfile()
	}
	
	func getProfile() {
		do {
			let result = try repo.fetchAll()
			guard let profile = result.first else { return }
			self.profile = profile
		} catch {
			self.errorMessage = "Could not get profile: \(error)"
		}
	}
	
	func save() {
		
	}
	
}
