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
	@ObservedObject var quizViewModel: QuizViewModel
	
	private let levels: [ArchLevel] = [
		.init(title: "MVC", subtitle: "Camadas Básicas"),
		.init(title: "MVVM", subtitle: "Estado Reativo")
	]
	@State var selectionID: ArchLevel.ID?
	
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
			
			VStack(alignment: .leading) {
				Divider()
				Text("Visualizações")
					.font(.title3)
					.bold()
					.foregroundStyle(.accent)
					.padding(.horizontal)
				
				Carousel(items: levels, selection: $selectionID, spacing: 30) { item in
					NavigationLink {
						switch item.title {
						case "MVVM":
							MVVMView()
						default:
							Text("Ish")
						}
					} label: {
						ArchitectureLevelCard(title: item.title, subtitle: item.subtitle)
							.clipShape(RoundedRectangle(cornerRadius: 16))
							.shadow(radius: 6)
					}
				}
			}
			
			
			VStack(alignment: .leading) {
				Divider()
				Text("Desafios")
					.font(.title3)
					.bold()
					.foregroundStyle(.accent)
					.padding(.horizontal)
				
				Carousel(items: quizViewModel.quizzes, selection: $quizViewModel.quizSelectionID) { quiz in
					NavigationLink {
						QuizView(quizViewModel: quizViewModel, quiz: quiz)
					} label: {
						ArchitectureLevelCard(title: quiz.title ?? "Quiz Title", subtitle: "")
							.clipShape(RoundedRectangle(cornerRadius: 16))
							.shadow(radius: 6)
					}
				}
			}
			
			Spacer()
		}
		.ignoresSafeArea()
	}
}

#Preview {
	ContentView(profileViewModel: ProfileViewModel(),
					notesViewModel: NotesViewModel(),
					quizViewModel: QuizViewModel())
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
