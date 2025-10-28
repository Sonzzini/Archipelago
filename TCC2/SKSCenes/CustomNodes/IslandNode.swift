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
	
	init(imageNamed: String = "Island1", size: CGSize = CGSize(width: 100, height: 100), name: String = "") {
		self.sprite = SKSpriteNode(imageNamed: imageNamed)
		super.init()
		
		sprite.size = size
		sprite.position = .zero
		
		self.name = name
		
		addChild(sprite)
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
