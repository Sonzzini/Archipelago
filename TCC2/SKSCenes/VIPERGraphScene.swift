//
//  VIPERGraphScene.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 02/12/25.
//

import Foundation
import SpriteKit
import Combine

final class VIPERGraphScene: SKScene, ObservableObject {
	
	@Published var selectedNode: IslandNode? = nil
	@Published var detailSheetIsPresented: Bool = false
	@Published var shouldSendMessage: Bool = false
	
	// NODES:
	// V - VIEW
	// I - INTERACTOR
	// P - PRESENTER
	// E - ENTITY
	// R - ROUTER
	
	let viewNode = IslandNode(type: .view)
	let interactorNode = IslandNode(type: .interactor)
	let presenterNode = IslandNode(type: .presenter)
	let entityNode = IslandNode(type: .entity)
	let routerNode = IslandNode(type: .router)
	
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
		
		viewNode.position = CGPoint(x: canvas.midX, y: canvas.midY - spacing)
		
		interactorNode.position = CGPoint(x: canvas.midX - spacing/3, y: canvas.midY - spacing / 3)
		presenterNode.position = CGPoint(x: canvas.midX + spacing/3, y: canvas.midY - spacing / 3)
		
		entityNode.position = CGPoint(x: canvas.midX - spacing/3, y: canvas.midY + spacing/3)
		routerNode.position = CGPoint(x: canvas.midX + spacing/3, y: canvas.midY + spacing/3)
		
		// MARK: Adicionar os nós na cena
		
		for node in [viewNode, interactorNode, presenterNode, entityNode, routerNode] {
			if node.parent == nil {
				addChild(node)
			}
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
				case .interactor:
					selectedNode = interactorNode
					detailSheetIsPresented.toggle()
				case .presenter:
					selectedNode = presenterNode
					detailSheetIsPresented.toggle()
				case .router:
					selectedNode = routerNode
					detailSheetIsPresented.toggle()
				case .entity:
					selectedNode = entityNode
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
	
	func routeVIPER(from origin: IslandType) {
		switch origin {
		case .view:
			
			viewNode.status = "Awaiting Response"
			send(message: "UserTapped", from: viewNode, to: presenterNode) { [weak self] in
				guard let self else { return }
				presenterNode.status = "Validating Information"
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
					self.presenterNode.status = "OK"
					
					self.send(message: "Info to Save", from: self.presenterNode, to: self.interactorNode) { [weak self] in
						guard let self else { return }
						self.interactorNode.status = "Received Info"
						self.presenterNode.status = "Awaiting Response"
						
						self.send(message: "Save", from: self.interactorNode, to: self.entityNode) { [weak self] in
							guard let self else { return }
							self.entityNode.status = "Saved(ok)"
							self.interactorNode.status = "Awaiting Response"
							
							self.send(message: "Save Complete", from: self.entityNode, to: self.interactorNode) { [weak self] in
								guard let self else { return }
								self.interactorNode.status = "OK"
								self.entityNode.status = "Stand-By"
								
								self.send(message: "Save Success", from: self.interactorNode, to: self.presenterNode) { [weak self] in
									guard let self else { return }
									self.presenterNode.status = "OK"
									self.interactorNode.status = "Stand-By"
									
									DispatchQueue.main.async {
										self.send(message: "Present list view", from: self.presenterNode, to: self.routerNode) { [weak self] in
											guard let self else { return }
											routerNode.status = "Routing views"
											
											DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
												self.routerNode.status = "Stand-By"
											}
										}
									}
									
									self.send(message: "UI Update", from: self.presenterNode, to: self.viewNode) { [weak self] in
										guard let self else { return }
										self.viewNode.status = "UI Updated!"
										self.presenterNode.status = "Stand-By"
										
										DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
											self.viewNode.status = "Stand-By"
										}
									}
								}
							}
						}
					}
				}
			}
			
		case .interactor:
			self.interactorNode.status = "Received Info"
			self.presenterNode.status = "Awaiting Response"
			
			self.send(message: "Save", from: self.interactorNode, to: self.entityNode) { [weak self] in
				guard let self else { return }
				self.entityNode.status = "Saved(ok)"
				self.interactorNode.status = "Awaiting Response"
				
				self.send(message: "Save Complete", from: self.entityNode, to: self.interactorNode) { [weak self] in
					guard let self else { return }
					self.interactorNode.status = "OK"
					self.entityNode.status = "Stand-By"
					
					self.send(message: "Save Success", from: self.interactorNode, to: self.presenterNode) { [weak self] in
						guard let self else { return }
						self.presenterNode.status = "OK"
						self.interactorNode.status = "Stand-By"
						
						DispatchQueue.main.async {
							self.send(message: "Present list view", from: self.presenterNode, to: self.routerNode) { [weak self] in
								guard let self else { return }
								routerNode.status = "Routing views"
								
								DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
									self.routerNode.status = "Stand-By"
								}
							}
						}
						
						self.send(message: "UI Update", from: self.presenterNode, to: self.viewNode) { [weak self] in
							guard let self else { return }
							self.viewNode.status = "UI Updated!"
							self.presenterNode.status = "Stand-By"
							
							DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
								self.viewNode.status = "Stand-By"
							}
						}
					}
				}
			}
			
		case .presenter:
			presenterNode.status = "Validating Information"
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
				self.presenterNode.status = "OK"
				
				self.send(message: "Info to Save", from: self.presenterNode, to: self.interactorNode) { [weak self] in
					guard let self else { return }
					self.interactorNode.status = "Received Info"
					self.presenterNode.status = "Awaiting Response"
					
					self.send(message: "Save", from: self.interactorNode, to: self.entityNode) { [weak self] in
						guard let self else { return }
						self.entityNode.status = "Saved(ok)"
						self.interactorNode.status = "Awaiting Response"
						
						self.send(message: "Save Complete", from: self.entityNode, to: self.interactorNode) { [weak self] in
							guard let self else { return }
							self.interactorNode.status = "OK"
							self.entityNode.status = "Stand-By"
							
							self.send(message: "Save Success", from: self.interactorNode, to: self.presenterNode) { [weak self] in
								guard let self else { return }
								self.presenterNode.status = "OK"
								self.interactorNode.status = "Stand-By"
								
								DispatchQueue.main.async {
									self.send(message: "Present list view", from: self.presenterNode, to: self.routerNode) { [weak self] in
										guard let self else { return }
										routerNode.status = "Routing views"
										
										DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
											self.routerNode.status = "Stand-By"
										}
									}
								}
								
								self.send(message: "UI Update", from: self.presenterNode, to: self.viewNode) { [weak self] in
									guard let self else { return }
									self.viewNode.status = "UI Updated!"
									self.presenterNode.status = "Stand-By"
									
									DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
										self.viewNode.status = "Stand-By"
									}
								}
							}
						}
					}
				}
			}
			
		case .router:
			routerNode.status = "Error!"
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
				self.routerNode.status = "I can't do this!"
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
					self.routerNode.status = "I route views!"
					
					DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
						self.routerNode.status = "Stand-By"
					}
				}
			}
			
		case .entity:
			entityNode.status = "Error!"
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
				self.entityNode.status = "I can't do this!"
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
					self.entityNode.status = "I represent models"
					
					DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
						self.entityNode.status = "Stand-By"
					}
				}
			}
			
		default: break
		}
	}
	
}
