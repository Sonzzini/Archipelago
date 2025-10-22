//
//  FeatureHighlightView.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 19/10/25.
//

import SwiftUI

struct FeatureHighlightView: View {
	
	@Environment(\.accessibilityReduceMotion) var reduceMotion
	
	var body: some View {
		TimelineView(.animation) { timeline in
			
			let t = timeline.date.timeIntervalSinceReferenceDate
			let xoffset = sin(t * 2) * 10
			let yoffset = cos(t * 2) * 10
			
			GeometryReader { geo in
				ZStack {
					Text("Aqui você poderá")
						.position(x: geo.size.width / 2, y: geo.size.height / 4.5)
						.font(.largeTitle)
						.multilineTextAlignment(.center)
						.bold()
					
					FeatureBubble(text: "Visualizar as principais arquiteturas iOS", isPrimary: true)
						.frame(maxWidth: min(geo.size.width * 0.75, 360))
						.padding(.vertical, 24)
						.offset(x: xoffset * 0.3, y: yoffset * 0.3)
					
					FeatureBubble(text: "Criar notas!")
						.position(x: 120 + xoffset, y: 250 + yoffset)
					
					FeatureBubble(text: "Avançar na jornada!")
						.position(x: 280 + xoffset, y: 300 - yoffset)
					
					FeatureBubble(text: "Testar seus conhecimentos!")
						.position(x: geo.size.width / 2 - xoffset, y: 500 + yoffset)
				}
			}
		}
	}
}

#Preview {
	FeatureHighlightView()
}
