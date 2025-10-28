//
//  MVVMGraphScene.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 27/10/25.
//

import Foundation
import SpriteKit
import Combine

final class MVVMGraphScene: SKScene, ObservableObject {
	
	@Published var selectedNode: IslandNode? = nil
	@Published var detailSheetIsPresented: Bool = false
	@Published var shouldSendMessage: Bool = false
	
	let viewNode = IslandNode(type: .view)
	let modelNode = IslandNode(type: .model)
	let viewModelNode = IslandNode(type: .viewModel)
	
	let nodeWidth: CGFloat = 100
	let nodeHeight: CGFloat = 100
	
	override func didMove(to view: SKView) {
		super.didMove(to: view)
		rebuild()
	}
	
	private func rebuild() {
		removeAllChildren()
		addBackground()
		addWaves()
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
	
	private func addWaves() {
		let w1 = WaveNode(size: CGSize(width: 120, height: 40))
		let w2 = WaveNode(size: CGSize(width: 100, height: 36), alpha: 0.8)
		let w3 = WaveNode(size: CGSize(width: 140, height: 44), alpha: 0.85)
		
		for node in [w1, w2, w3] {
			if node.parent == nil { addChild(node) }
		}
		
		w1.animateInfinity(around: CGPoint(x: frame.midX / 2 + 40, y: frame.midY / 2), ax: 28, ay: 10, period: 3.6, phase: 0)
		w2.animateInfinity(around: CGPoint(x: frame.midX / 2 - 60, y: frame.midY / 2 - 80), ax: 34, ay: 12, period: 4.2, phase: .pi / 2)
		w3.animateInfinity(around: CGPoint(x: frame.midX / 2 - 45, y: frame.midY / 2 + 70), ax: 24, ay: 8, period: 3.0, phase: .pi)
	}
	
	private func buildGraph() {
		guard size.width > 0, size.height > 0 else { return }
		
		// MARK: Layout adaptativo
		
		let margin: CGFloat = 24
		let canvas = frame.insetBy(dx: margin, dy: margin)
		let spacing = min(canvas.width, canvas.height) * 0.9
		
		viewModelNode.position 	= CGPoint(x: canvas.midX - spacing/3, y: canvas.midY)
		viewNode.position 		= CGPoint(x: canvas.midX + spacing/3, y: canvas.midY - spacing/2)
		modelNode.position 		= CGPoint(x: canvas.midX + spacing/3, y: canvas.midY + spacing/2)
		
		// MARK: Adicionar os nós na cena
		
		for node in [viewNode, modelNode, viewModelNode] {
			if node.parent == nil { addChild(node) }
		}
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let t = touches.first else { return }
		let location = t.location(in: self)
		
		let nodesAtPoint = nodes(at: location)
		
		for node in nodesAtPoint {
			if let island = node as? IslandNode {
				switch island.type {
				case .view:
					selectedNode = viewNode
					detailSheetIsPresented.toggle()
				case .model:
					selectedNode = modelNode
					detailSheetIsPresented.toggle()
				case .viewModel:
					selectedNode = viewModelNode
					detailSheetIsPresented.toggle()
				default:
					selectedNode = nil
				}
			}
		}
		
		print("Não tocou em nada principal!")
	}
	
	func send(message: String, from a: IslandNode, to b: IslandNode, arcHeight: CGFloat = 60, seconds: TimeInterval = 3, completion: (() -> Void)? = nil) {
		guard let scene = a.scene else { return }
		let p0 = a.parent == scene ? a.position : scene.convert(a.position, from: a.parent!)
		let p3 = b.parent == scene ? b.position : scene.convert(b.position, from: b.parent!)
		
		let mid = CGPoint(x: (p0.x + p3.x)/2, y: (p0.y + p3.y)/2 + arcHeight)
		
		let path = CGMutablePath()
		path.move(to: p0)
		path.addQuadCurve(to: p3, control: mid)
		
		let traveler = BoatNode(message: message)
		traveler.removeAllActions()
		traveler.position = p0
		traveler.zPosition = max(a.zPosition, b.zPosition) + 1
		
		if traveler.parent == nil { addChild(traveler) }
		
		let follow = SKAction.follow(path, asOffset: false, orientToPath: false, duration: seconds)
		follow.timingMode = .easeInEaseOut
		
		traveler.run(.sequence([ follow, .removeFromParent(), .run { completion?() } ]))
	}
	
	func routeMVVM(from origin: IslandType) {
		switch origin {
		case .view:
			
			viewNode.status = "Awaiting Response"
			send(message: "UserTapped", from: viewNode, to: viewModelNode) { [weak self] in
				guard let self else { return }
				viewModelNode.status = "Processing"
				
				self.send(message: "ProcessTask", from: self.viewModelNode, to: self.modelNode) { [weak self] in
					guard let self else { return }
					viewModelNode.status = "Awaiting Response"
					modelNode.status = "Processing"
					
					self.send(message: "Saved(ok)", from: self.modelNode, to: self.viewModelNode) { [weak self] in
						guard let self else { return }
						modelNode.status = "Stand-By"
						viewModelNode.status = "Received OK!"
						
						self.send(message: "UI Update", from: self.viewModelNode, to: self.viewNode) { [weak self] in
							guard let self else { return }
							viewNode.status = "UI Updated!"
							viewModelNode.status = "Stand-By"
							
							DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
								self.viewNode.status = "Stand-By"
								self.viewModelNode.status = "Stand-By"
								self.modelNode.status = "Stand-By"
							}
						}
					}
				}
				
			}
			
		case .model:
			send(message: "Saved(ok)", from: modelNode, to: viewModelNode) { [weak self] in
				guard let self else { return }
				  self.send(message: "UI Update", from: self.viewModelNode, to: self.viewNode)
			  }
			
		case .viewModel:
			send(message: "ProcessTask", from: viewModelNode, to: modelNode) { [weak self] in
				guard let self else { return }
				self.send(message: "Saved(ok)", from: self.modelNode, to: self.viewModelNode) { [weak self] in
					guard let self else { return }
					self.send(message: "UI Update", from: self.viewModelNode, to: self.viewNode)
				}
			}
			
		default:
			break
		}
	}
}
