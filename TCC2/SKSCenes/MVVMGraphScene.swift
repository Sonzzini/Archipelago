//
//  MVVMGraphScene.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 27/10/25.
//

import Foundation
import SpriteKit
import Combine

final class MVVMGraphScene: SKScene {
	
	private let ui: GraphUIState
	private var cancellables = Set<AnyCancellable>()
	
	let viewNode = IslandNode(imageNamed: "Island1", size: CGSize(width: 100, height: 100), name: "View")
	let modelNode = IslandNode(imageNamed: "Island1", size: CGSize(width: 100, height: 100), name: "Model")
	let viewModelNode = IslandNode(imageNamed: "Island1", size: CGSize(width: 100, height: 100), name: "ViewModel")
	
	let nodeWidth: CGFloat = 100
	let nodeHeight: CGFloat = 100
	
	init(size: CGSize, ui: GraphUIState) {
		self.ui = ui
		super.init(size: size)
		scaleMode = .resizeFill
		
		ui.$pendingIntent
			.compactMap { $0 }
			.sink { [weak self] intent in
				self?.handle(intent: intent)
				DispatchQueue.main.async { [weak ui] in ui?.pendingIntent = nil }
			}
			.store(in: &cancellables)
	}
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	override func didMove(to view: SKView) {
		super.didMove(to: view)
		rebuild()
	}
	
	private func rebuild() {
		removeAllChildren()
		addBackground()
		buildGraph()
	}
	
	override func didChangeSize(_ oldSize: CGSize) {
		super.didChangeSize(oldSize)
		rebuild()
	}
	
	private func addBackground() {
		guard size.width > 0, size.height > 0 else { return }
		let bg = SKSpriteNode(imageNamed: "SeaBackground")
		bg.name = "bg"
		bg.zPosition = -1000
		bg.size = size
		bg.position = CGPoint(x: frame.midX, y: frame.midY)
		addChild(bg)
	}
	
	private func buildGraph() {
		guard size.width > 0, size.height > 0 else { return }
		
		// MARK: Layout adaptativo
		
		let margin: CGFloat = 24
		let canvas = frame.insetBy(dx: margin, dy: margin)
		let spacing = min(canvas.width, canvas.height) * 0.45
		
		viewModelNode.position 	= CGPoint(x: canvas.midX, y: canvas.midY)
		viewNode.position 		= CGPoint(x: canvas.midX, y: canvas.midY - spacing/2)
		modelNode.position 		= CGPoint(x: canvas.midX, y: canvas.midY + spacing/2)
		
		// MARK: Adicionar os nós na cena
		
		for node in [viewNode, modelNode, viewModelNode] {
			if node.parent == nil { addChild(node) }
		}
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let t = touches.first else { return }
		let p = t.location(in: self)
		selectNode(at: p)
		
	}
	
	private func selectNode(at point: CGPoint) {
		let hit = nodes(at: point)
		if hit.contains(where: { $0 === viewNode || $0.inParentHierarchy(viewNode) }) {
			ui.selected = NodeDescriptor(role: .view,
												  title: "View",
												  details: "Origina intenções do usuário (User Intents).")
		} else if hit.contains(where: { $0 === viewModelNode || $0.inParentHierarchy(viewModelNode) }) {
			ui.selected = NodeDescriptor(role: .viewModel,
												  title: "ViewModel",
												  details: "Processa intenções, orquestra, expõe estados.")
		} else if hit.contains(where: { $0 === modelNode || $0.inParentHierarchy(modelNode) }) {
			ui.selected = NodeDescriptor(role: .model,
												  title: "Model",
												  details: "Regra de domínio/dados, persistência, serviços.")
		} else {
			ui.selected = nil
		}
	}
}


extension MVVMGraphScene {
	private func handle(intent: GraphIntent) {
		switch intent {
		case .emitAction(from: let role):
			runEmitAnimation(from: role)
		case .highlight(role: let role):
			pulse(role: role)
		case .clear:
			removeAllActions()
		}
	}
	
	private func pulse(role: ComponentRole) {
		let node = node(for: role)
		let seq = SKAction.sequence([.scale(by: 1.1, duration: 0.2), .scale(by: 0.9, duration: 0.2)])
		node?.run(seq)
	}
	
	private func runEmitAnimation(from role: ComponentRole) {
		
	}
	
	private func node(for role: ComponentRole) -> SKNode? {
		switch role {
		case .view: return viewNode
		case .model: return modelNode
		case .viewModel: return viewModelNode
		case .controller: return nil
		}
	}
}
