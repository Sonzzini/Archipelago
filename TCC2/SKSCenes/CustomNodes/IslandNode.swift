//
//  IslandNode.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 27/10/25.
//

import Foundation
import SpriteKit

final class IslandNode: SKNode {
	
	private let sprite: SKSpriteNode
	private let label: SKLabelNode
	
	let type: IslandType
	var status: String {
		get {
			return self.label.text ?? ""
		}
		set {
			self.label.text = newValue
		}
	}
	
	init(type: IslandType, imageNamed: String = "Island1", size: CGSize = CGSize(width: 150, height: 150)) {
		self.type = type
		
		switch type {
		case .view:
			self.sprite = SKSpriteNode(imageNamed: "ViewIsland")
		case .model:
			self.sprite = SKSpriteNode(imageNamed: "ModelIsland")
		case .viewModel:
			self.sprite = SKSpriteNode(imageNamed: "ViewModelIsland")
		case .controller:
			self.sprite = SKSpriteNode(imageNamed: imageNamed)
		case .interactor:
			self.sprite = SKSpriteNode(imageNamed: imageNamed)
		case .presenter:
			self.sprite = SKSpriteNode(imageNamed: imageNamed)
		case .router:
			self.sprite = SKSpriteNode(imageNamed: imageNamed)
		case .entity:
			self.sprite = SKSpriteNode(imageNamed: imageNamed)
		}
		
		self.label = SKLabelNode(text: "Stand-By")
		label.fontName = "Avenir-Heavy"
		label.fontSize = 22
		label.fontColor = .white
		label.verticalAlignmentMode = .center
		label.horizontalAlignmentMode = .center
		label.position = CGPoint(x: 0, y: +sprite.size.height / 2 + 10)
		
		let titleLabel = SKLabelNode(text: type.rawValue)
		titleLabel.fontName = "Avenir-Heavy"
		titleLabel.fontSize = 16
		titleLabel.fontColor = .white
		titleLabel.verticalAlignmentMode = .center
		titleLabel.horizontalAlignmentMode = .center
		titleLabel.position = CGPoint(x: 0, y: -sprite.size.height / 2 - 10)
		
		super.init()
		
		self.name = type.rawValue
		
		sprite.size = size
		sprite.position = .zero
		
		addChild(sprite)
		
		addChild(label)
		
		addChild(titleLabel)
	}
	
	func changeStatus(to newStatus: String) {
		self.status = "STATUS: \(newStatus)"
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

enum IslandType: String, CaseIterable {
	case view = "View"
	case model = "Model"
	case viewModel = "ViewModel"
	case controller = "Controller"
	case interactor = "Interactor"
	case presenter = "Presenter"
	case router = "Router"
	case entity = "Entity"
	
	var description: String {
		switch self {
		case .view:
			"Camada responsável pela interface visual e pela interação com o usuário. Exibe dados e encaminha eventos (toques, ações) para a camada lógica — sem conter regra de negócio."
		case .model:
			"Representa os dados e regras do domínio. Contém lógica de negócio pura, validações e invariantes, independente de UI ou camada visual."
		case .viewModel:
			"Interpreta intenções da View, aplica lógica de apresentação e expõe estados observáveis. Faz a ponte entre UI e domínio, sem conhecer a View diretamente."
		case .controller:
			"Coordena o fluxo entre View e lógica, recebendo ações e direcionando para ViewModel/Interactor. Não deve conter regra de negócio, apenas orquestra."
		case .interactor:
			"O cérebro da regra de negócio. Executa casos de uso (use cases), chama serviços/API e retorna resultados processados para o Presenter."
		case .presenter:
			"Formata os dados do Interactor para exibição, adaptando linguagem técnica em algo visualmente pronto para a View (ex: strings, cores, labels)."
		case .router:
			"Responsável pela navegação. Decide para onde ir e monta módulos/páginas, sem lógica de negócio nem UI."
		case .entity:
			"Modelo de domínio puro. Representa dados verdadeiros e consistentes, usados dentro dos casos de uso. Não conhece interface nem storage."
		}
	}
}

