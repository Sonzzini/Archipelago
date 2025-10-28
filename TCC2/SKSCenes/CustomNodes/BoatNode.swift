//
//  BoatNode.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 28/10/25.
//

import Foundation
import SpriteKit

final class BoatNode: SKNode {
	
	private let sprite: SKSpriteNode
	let message: String
	
	init(message: String) {
		self.message = message
		self.sprite = SKSpriteNode(imageNamed: "Boat")
		super.init()
		
		addChild(sprite)
		
		let label = SKLabelNode(text: message)
		label.fontSize = 22
		label.fontName = "Avenir-Heavy"
		label.fontColor = .white
		label.horizontalAlignmentMode = .center
		label.verticalAlignmentMode = .center
		label.position = CGPoint(x: 0, y: +sprite.size.height / 2 + 10)
		label.zPosition = 1234567890
		addChild(label)
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
}
