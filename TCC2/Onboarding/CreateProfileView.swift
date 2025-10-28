//
//  CreateProfileView.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 24/10/25.
//

import SwiftUI

struct CreateProfileView: View {
	
	@Environment(\.dismiss) var dismiss
	@ObservedObject var profileViewModel: ProfileViewModel
	@State var profileName: String = ""
	
	var body: some View {
		VStack {
			Text("Como podemos te chamar?")
				.font(.largeTitle)
				.multilineTextAlignment(.center)
			
			TextField("Seu Nome", text: $profileName)
				.font(.title)
				.textFieldStyle(.roundedBorder)
				.padding(.vertical, 150)
			
			Button {
				DataController.shared.finishProfileSetup(with: profileName)
				profileViewModel.getProfile()
				dismiss()
			} label: {
				Text("Embarcar na jornada!")
					.font(.title2)
					.padding(10)
			}
			.disabled(profileName.isEmpty)
			.buttonStyle(.glassProminent)
		}
		.padding(.horizontal)
	}
}

#Preview {
	CreateProfileView(profileViewModel: ProfileViewModel())
}
