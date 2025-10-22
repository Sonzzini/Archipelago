//
//  IntroView.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 19/10/25.
//

import SwiftUI

import SwiftUI
import Combine

struct IntroView: View {
	private let symbols = [
		"globe.americas",
		"globe.europe.africa",
		"globe.central.south.asia",
		"globe.asia.australia"
	]
	
	@State private var index = 0
	@State private var reduceMotion = UIAccessibility.isReduceMotionEnabled
	
	private let interval: TimeInterval = 2
	private var timer = Timer.publish(every: 0.8, on: .main, in: .common).autoconnect()
	
	var body: some View {
		VStack {
			Text("Boas vindas ao Archipelago!")
				.font(.largeTitle)
				.multilineTextAlignment(.center)
				.padding(.bottom, 50)
			
			ZStack {
				// Usamos ZStack + id para animar a troca com fade
				Image(systemName: symbols[index])
					.font(.system(size: 100))
					.id(symbols[index])
					.transition(.opacity)
					.animation(.easeInOut(duration: 0.5), value: symbols[index])
			}
		}
		.onReceive(timer) { _ in
			guard !reduceMotion else { return }
			withAnimation {
				index = (index + 1) % symbols.count
			}
		}
		.onAppear {
			// Reage a mudanças de acessibilidade
			reduceMotion = UIAccessibility.isReduceMotionEnabled
		}
	}
}

#Preview {
	IntroView()
}
