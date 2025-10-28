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
	
//	let repo: DataRepository<ProfileEntity>
	
	init() {
//		self.repo = DataRepository<ProfileEntity>()
		getProfile()
	}
	
	func getProfile() {
		let result = DataController.shared.fetchProfile()
		
		switch result {
		case .success(let profile):
			self.profile = profile
		case .failure(let error):
			self.errorMessage = error.localizedDescription
		}

	}
	
	func deleteProfile() {
		let result = DataController.shared.deleteProfile()
		
		switch result {
		case .success(let profileName):
			print("Successfully deleted profile: \(profileName)")
		case .failure(let error):
			self.errorMessage = error.localizedDescription
		}
	}
	
	func editProfile(with newName: String) {
		let result = DataController.shared.editProfile(with: newName)
		
		switch result {
		case .success(let profile):
			self.profile = profile
		case .failure(let error):
			self.errorMessage = "Could not update profile name: \(error)"
		}
	}
	
}
