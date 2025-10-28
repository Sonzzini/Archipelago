//
//  MVVMView.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 27/10/25.
//

import SwiftUI
import SpriteKit

struct MVVMView: View {
	
	@StateObject var scene: MVVMGraphScene = .init()
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
					
					Text("Arquitetura Model-View-ViewModel (MVVM)")
						.bold()
					
					if shouldShowHints {
						FloatingHint("Toque em uma ilha para começar!")
							.font(.callout.bold())
					}
					
					Spacer()
				}
				
			}
			.sheet(isPresented: $scene.detailSheetIsPresented) {
				if let node = scene.selectedNode {
					NodePopup(node: node, onEmit: {
						scene.routeMVVM(from: node.type)
					})
						.presentationDetents([.fraction(0.5)])
						.presentationDragIndicator(.visible)
				}
			}
			.sheet(isPresented: $codeSnippetSheetIsPresented) {
				CodeSnippetView(code: """

import SwiftUI

struct ContentView: View {

	@StateObject var viewModel = ViewModel()

	var body: some View {
		Button("Create Model") { viewModel.createModel(with: "John") }
		List(viewModel.models) { model in
			Text(model.name)
		}
	}
}

class ViewModel: ObservableObject {
	@Published var models: [Model]

	func createModel(with name: String) {
		let newModel = Model(name: name)
		newModel.save()
		self.models.append(newModel)
	}
}

struct Model {
	let name: String

	func save() {
		persistence.save(self)
	}
}

""")
			}
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						codeSnippetSheetIsPresented.toggle()
					} label: {
						Image(systemName: "chevron.left.chevron.right")
					}
				}
			}
			.onChange(of: scene.detailSheetIsPresented) { oldValue, newValue in
				withAnimation(.easeInOut(duration: 2)) {
					shouldShowHints = false
				}
			}
			
		}
	}
}


#Preview {
	MVVMView()
}
