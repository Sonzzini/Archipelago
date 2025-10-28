//
//  MVVMView.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 27/10/25.
//

import SwiftUI
import SpriteKit

struct MVVMView: View {
	
	@StateObject var ui = GraphUIState()
	@State var scene: MVVMGraphScene = .init(size: .zero, ui: GraphUIState()) // será substituída no onAppear
	
	var body: some View {
		
		GeometryReader { proxy in
			
			let size = proxy.size
			
			ZStack {
				
				SpriteView(scene: scene)
					.onAppear {
						scene = MVVMGraphScene(size: size, ui: ui)
						scene.scaleMode = .resizeFill
						scene.size = size
					}
					.onChange(of: size) { oldValue, newValue in
						scene.size = newValue
					}
				
			}
			.ignoresSafeArea()
			.navigationTitle("Arquitetura MVVM")
			.sheet(item: $ui.selected) { node in
				NodePopup(node: node) { action in
					ui.pendingIntent = action
				}
				.presentationDetents([.fraction(0.5)])
				.presentationDragIndicator(.visible)
			}
			
		}
	}
}


#Preview {
	MVVMView()
}
