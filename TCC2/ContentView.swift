//
//  ContentView.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 19/10/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
	
	@ObservedObject var profileViewModel: ProfileViewModel
	@ObservedObject var notesViewModel: NotesViewModel
	
	var body: some View {
		NavigationStack {
			
			HStack {
				
				NavigationLink {
					EditProfileView(profileViewModel: profileViewModel, profile: profileViewModel.profile ?? .init())
				} label: {
					profileBar
				}
				
				Spacer()
				
				NavigationLink {
					NotesView(notesViewModel: notesViewModel)
				} label: {
					Image(systemName: "square.and.pencil")
				}
				.buttonStyle(.glass)
			}
			.font(.title2)
			.padding(.horizontal)
			Spacer()
		}
		.ignoresSafeArea()
	}
}

#Preview {
	ContentView(profileViewModel: ProfileViewModel(),
					notesViewModel: NotesViewModel())
}

extension ContentView {
	
	private var profileBar: some View {
		HStack {
			let experience = CGFloat(min(max(profileViewModel.profile?.experience ?? 0, 0), 1))
			
			ZStack {
				Circle()
					.stroke(lineWidth: 10)
				
				Circle()
					.trim(from: 0, to: experience)
					.stroke(.accent, style: StrokeStyle(
						lineWidth: 12,
						lineCap: .round // deixa a borda arredondada!
					))
					.rotationEffect(.degrees(-90))
					.animation(.easeInOut, value: experience)
				
				Text("\(profileViewModel.profile?.level ?? 1)")
			}
			.frame(height: 50)
			
			Text("\(profileViewModel.profile?.name ?? "Unknown Name")")
		}
	}
	
}
