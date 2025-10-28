//
//  WaveNode.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 28/10/25.
//

import Foundation
import SpriteKit

final class WaveNode: SKNode {
	private let sprite: SKSpriteNode
	
	init(size: CGSize, z: CGFloat = -500, alpha: CGFloat = 0.9) {
		self.sprite = SKSpriteNode(imageNamed: "Wave")
		super.init()
		sprite.size = size
		sprite.alpha = alpha
		sprite.zPosition = z
		addChild(sprite)
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	func animateInfinity(around center: CGPoint, ax: CGFloat, ay: CGFloat, period: TimeInterval, phase: CGFloat = 0) {
		let path = makeInfinityPath(center: center, ax: ax, ay: ay, phase: phase)

		if let first = path.currentPointOptional { self.position = first }

		let follow = SKAction.follow(path, asOffset: false, orientToPath: false, duration: period)
		follow.timingMode = .easeInEaseOut
		let forever = SKAction.repeatForever(follow)
		sprite.run(forever, withKey: "waveInfinity")
	}
}

func makeInfinityPath(center: CGPoint, ax: CGFloat, ay: CGFloat, samples: Int = 240, phase: CGFloat = 0) -> CGPath {
	 let path = CGMutablePath()
	 let twoPi = CGFloat.pi * 2
	 var first = true
	 for i in 0...samples {
		  let t = (CGFloat(i)/CGFloat(samples)) * twoPi + phase
		  let x = center.x + ax * sin(t)
		  let y = center.y + ay * sin(t) * cos(t) // (ay/2)*sin(2t)
		  let p = CGPoint(x: x, y: y)
		  first ? path.move(to: p) : path.addLine(to: p)
		  first = false
	 }
	 return path
}

private extension CGPath {
	 var currentPointOptional: CGPoint? {
		  var point: CGPoint?
		  applyWithBlock { elemPtr in
				let elem = elemPtr.pointee
				if elem.type == .moveToPoint || elem.type == .addLineToPoint {
					 point = elem.points[0]
				}
		  }
		  return point
	 }
}
