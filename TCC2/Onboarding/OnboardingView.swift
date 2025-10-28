//
//  OnboardingView.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 19/10/25.
//

import SwiftUI

struct OnboardingView: View {
	
	@Environment(\.colorScheme) var colorScheme
	
	@ObservedObject var profileViewModel: ProfileViewModel
	
	@State var currentViewIndex: Int = 0
	
	var body: some View {
		ZStack {
			TabView(selection: $currentViewIndex) {
				IntroView()					.tag(0)
				FeatureHighlightView()	.tag(1)
				CreateProfileView(profileViewModel: profileViewModel)		.tag(2)
			}
			.tabViewStyle(.page(indexDisplayMode: .always))
			.highPriorityGesture (
				DragGesture()
			)
			.background(
				Rectangle()
					.fill(
						Gradient(colors: colorScheme == .dark ? [.accent, .background] : [.background, .accent])
					)
			)
			
			VStack {
				Spacer()
				
				// TODO: Botão de avançar ficar no mesmo lugar
				if currentViewIndex < 2 {
					Button {
						withAnimation(.easeInOut(duration: 0.5)) {
							if currentViewIndex < 2 {
								currentViewIndex += 1
							}
						}
					} label: {
						Text("Avançar")
							.font(.title2)
							.padding(10)
					}
					.buttonStyle(.glassProminent)
				}
				
				if currentViewIndex > 0 {
					Button {
						withAnimation(.easeInOut(duration: 0.5)) {
							if currentViewIndex > 0 {
								currentViewIndex -= 1
							}
						}
					} label: {
						Text("Voltar")
							.foregroundStyle(.accent)
					}
					.buttonStyle(.glass)
				}
			}
			.padding(.bottom, 70)
		}
		.ignoresSafeArea()
	}
}

#Preview {
	OnboardingView(profileViewModel: ProfileViewModel())
}
