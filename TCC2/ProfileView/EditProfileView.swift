//
//  EditProfileView.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 24/10/25.
//

import SwiftUI
import CoreData

struct EditProfileView: View {
	
	@Environment(\.dismiss) var dismiss
	
	@ObservedObject var profileViewModel: ProfileViewModel
	
	let profile: ProfileEntity
	
	@State var isEditing: Bool = false
	@State var shouldShowConfirmDeleteAlert: Bool = false
	@State var shouldShowConfirmEditAlert: Bool = false
	@State var shouldShowInvalidNameAlert: Bool = false
	
	@State private var showSuccessHUD = false
	@State private var triggerHaptic = false
	
	@State var newName: String = ""
	
	var body: some View {
		VStack {
			if !isEditing {
				notEditingForm
			} else {
				isEditingForm
			}
		}
		.navigationTitle("Seu Perfil")
		.onAppear {
			newName = profile.name ?? ""
		}
		.overlay {
			if showSuccessHUD {
				SuccessHUD(text: "Salvo!")
					.onAppear {
						// iOS 16-: Feedback tátil via UIKit
						UIImpactFeedbackGenerator(style: .medium).impactOccurred()
					}
			}
		}
		.animation(.spring(response: 0.35, dampingFraction: 0.9), value: showSuccessHUD)
	}
}

#Preview {
	let profile = ProfileEntity(context: DataController.shared.viewContext)
	
	EditProfileView(profileViewModel: ProfileViewModel(), profile: profile)
}

extension EditProfileView {
	
	private var notEditingForm: some View {
		Form {
			Section {
				HStack {
					Spacer()
					Text("\(profile.name ?? "Unknown Name")")
						.font(.title)
					Spacer()
				}
				HStack {
					Text("Level: \(profile.level)")
					Spacer()
					Text("Experiência: \(profile.experience)")
				}
			}
			
			
			Section {
				HStack {
					Spacer()
					Button {
						withAnimation() {
							isEditing.toggle()
						}
					} label: {
						Text("Editar perfil")
					}
					Spacer()
				}
			}
			
			Section {
				HStack {
					Spacer()
					Button(role: .destructive) {
						shouldShowConfirmDeleteAlert = true
					} label: {
						Text("Excluir Perfil")
							.bold()
					}
					Spacer()
				}
			}
			.alert("Excluir perfil?", isPresented: $shouldShowConfirmDeleteAlert) {
				Button("Cancelar", role: .cancel) {}
				Button("Excluir", role: .destructive) {
					profileViewModel.deleteProfile()
					dismiss()
				}
			} message: {
				Text("Esta ação não pode ser desfeita.")
			}
		}
	}
	
	private var isEditingForm: some View {
		Form {
			Section {
				HStack {
					Spacer()
					Text("Novo Nome:")
					TextField("Novo Nome", text: $newName)
						.font(.title)
					Spacer()
				}
				HStack {
					Text("Level: \(profile.level)")
					Spacer()
					Text("Experiência: \(profile.experience)")
				}
			}
			
			Section {
				HStack {
					Spacer()
					Button {
						if newName.isEmpty {
							shouldShowInvalidNameAlert = true
						} else {
							shouldShowConfirmEditAlert = true
						}
					} label: {
						Text("Salvar alterações")
					}
					.alert("Salvar perfil?", isPresented: $shouldShowConfirmEditAlert) {
						Button("Cancelar", role: .cancel) {}
						Button("Salvar", role: .confirm) {
							profileViewModel.editProfile(with: newName)
							
							showSuccessHUD = true
							
							UINotificationFeedbackGenerator().notificationOccurred(.success)
							
							DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
								withAnimation {
									showSuccessHUD = false
									isEditing = false
								}
							}
						}
					} message: {
						Text("Seu novo nome será: \(newName)")
					}
					.alert("Nome inválido!", isPresented: $shouldShowInvalidNameAlert) {
						Button("Entendi") {}
					} message: {
						Text("Seu nome deve conter pelo menos 1 caractere.")
					}
					Spacer()
				}
			}
			
			Section {
				HStack {
					Spacer()
					Button {
						withAnimation() {
							isEditing.toggle()
						}
					} label: {
						Text("Cancelar")
					}
					Spacer()
				}
			}
		}
	}
}
