//
//  TCC2App.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 19/10/25.
//

import SwiftUI

@main
struct TCC2App: App {
	
	@StateObject var profileViewModel = ProfileViewModel()
	@StateObject var notesViewModel = NotesViewModel()
	
	@State var shouldPresentOnboarding: Bool = false
	
	var body: some Scene {
		WindowGroup {
			ContentView(profileViewModel: profileViewModel,
							notesViewModel: notesViewModel)
				.onAppear {
					shouldPresentOnboarding = DataController.shared.profileIsSetup()
				}
				.fullScreenCover(isPresented: $shouldPresentOnboarding) {
					OnboardingView(profileViewModel: profileViewModel)
				}
		}
	}
}
