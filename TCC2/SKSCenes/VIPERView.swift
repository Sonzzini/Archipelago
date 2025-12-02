//
//  VIPERView.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 02/12/25.
//

import SwiftUI
import SpriteKit

struct VIPERView: View {
	
	@StateObject var scene: VIPERGraphScene = .init()
	@State var shouldShowHints: Bool = true
	@State var codeSnippetSheetIsPresented = false
	
	var body: some View {
		GeometryReader { proxy in
			let size = proxy.size
			
			ZStack {
				
				SpriteView(scene: scene)
					.onAppear {
						scene.scaleMode = .resizeFill
						scene.size = size
					}
					.onChange(of: size) { oldValue, newValue in
						scene.size = newValue
					}
					.ignoresSafeArea()
				
				VStack {
					
					Text("Arquitetura VIPER (View-Interactor-Presenter-Entity-Router)")
						.multilineTextAlignment(.center)
						.bold()
					
					if shouldShowHints {
						FloatingHint("Toque em uma ilha para começar!")
							.font(.callout.bold())
					}
					
					Spacer()
					
				}
				.sheet(isPresented: $scene.detailSheetIsPresented) {
					if let node = scene.selectedNode {
						NodePopup(node: node, onEmit: {
							scene.routeVIPER(from: node.type)
						})
						.presentationDetents([.fraction((0.5))])
						.presentationDragIndicator(.visible)
					}
				}
				.sheet(isPresented: $codeSnippetSheetIsPresented) {
					CodeSnippetView(code:
"""
import SwiftUI

// MARK: - Entity
struct Note {
	let id: UUID
	let title: String
	let body: String
}

// MARK: - View & Presenter Protocols
protocol NewNoteViewProtocol: AnyObject {
	func showLoading(_ isLoading: Bool)
	func showSuccessAndClose()
}

protocol NewNotePresenterProtocol: AnyObject {
	func viewDidLoad()
	func didTapSaveButton(title: String, body: String)
}

// MARK: - Interactor Protocols
protocol NewNoteInteractorInputProtocol: AnyObject {
	func saveNote(title: String, body: String)
}

protocol NewNoteInteractorOutputProtocol: AnyObject {
	func saveNoteSucceeded(_ note: Note)
	func saveNoteFailed(_ error: Error)
}

// MARK: - Router Protocol
protocol NewNoteRouterProtocol: AnyObject {
	func closeNewNoteModule()
}


// MARK: - Implementation!
final class NewNoteViewController: UIViewController, NewNoteViewProtocol {
	
	var presenter: NewNotePresenterProtocol!

	@IBAction func saveButtonTapped(_ sender: UIButton) {
		presenter.didTapSaveButton(title: title, body: body)
	}
}


final class NewNotePresenter: NewNotePresenterProtocol {
	weak var view: NewNoteViewProtocol?
	var interactor: NewNoteInteractorInputProtocol!
	var router: NewNoteRouterProtocol!

	func didTapSaveButton(title: String, body: String) {
		// Validation
		view?.showLoading(true)

		interactor.saveNote(title: title, body: body)
	}
}

extension NewNotePresenter: NewNoteInteractorOutputProtocol {
	func saveNoteSucceeded(_ note: Note) {
		view?.showLoading(false)
		view?.showSuccessAndClose()
		router.closeNewNoteModule()
	}

	func saveNoteFailed(_ error: Error) {
		view?.showLoading(false)
		view?.showErrorMessage("Error saving new Note")
	}
}

protocol NotesRepositoryProtocol {
	func save(note: Note, completion: @escaping (Result<Note, Error>) -> Void)
}

final class NewNoteInteractor: NewNoteInteractorInputProtocol {
	weak var output: NewNoteInteractorOutputProtocol?
	private let repository: NotesRepositoryProtocol
	
	init(repository: NotesRepositoryProtocol) {
		self.repository = repository
	}

	func saveNote(title: String, body: String) {
		let note = Note(title: title, body: body)

		repository.saveNote(note: note) { [weak self] result in
			switch result {
			case .success(let savedNote):
				self?.output?.saveNoteSucceeded(savedNote)
			case .failure(let error):
				self?.output?.saveNoteFailed(error)
			}
		}
	}
}
""")
					.presentationDragIndicator(.visible)
				}
				.toolbar {
					ToolbarItem(placement: .topBarTrailing) {
						Button {
							codeSnippetSheetIsPresented.toggle()
						} label: {
							Image(systemName: "chevron.left.chevron,right")
						}
					}
				}
				.onChange(of: scene.detailSheetIsPresented) { oldValue, newValue in
					shouldShowHints = false
				}
				
			}
		}
	}
}

#Preview {
	VIPERView()
}
