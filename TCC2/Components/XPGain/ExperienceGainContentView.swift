//
//  ExperienceGainContentView.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 07/11/25.
//

import SwiftUI

struct ExperienceGainContentView: View {
	 let initialLevel: Int
	 let initialXP: Double
	 let gainedXP: Double
	 let onDismiss: () -> Void

	 @State private var currentLevel: Int = 0
	 @State private var currentXP: Double = 0       // 0...100
	 @State private var remainingXP: Double = 0
	 @State private var isAnimating: Bool = true

	 var body: some View {
		  VStack(spacing: 24) {
				Text("Nível \(currentLevel)")
					 .font(.largeTitle.bold())

				Text("+\(Int(gainedXP)) XP")
					 .font(.title3)
					 .foregroundStyle(.secondary)

				xpBar

				if isAnimating {
					 ProgressView("Atualizando experiência...")
						  .padding(.top, 8)
				}

				Button {
					 onDismiss()
				} label: {
					 Text("OK")
						  .bold()
						  .frame(maxWidth: .infinity)
						  .padding()
						  .background(isAnimating ? Color.gray.opacity(0.3) : Color.accentColor)
						  .foregroundColor(.white)
						  .clipShape(RoundedRectangle(cornerRadius: 12))
				}
				.disabled(isAnimating)
		  }
		  .padding(24)
		  .background(
				RoundedRectangle(cornerRadius: 20)
					 .fill(.ultraThinMaterial)
					 .shadow(radius: 10)
		  )
		  .padding()
		  .onAppear {
				setupInitialState()
				Task {
					 await startAnimation()
				}
		  }
	 }

	 // MARK: - Barra de XP

	 private var xpBar: some View {
		  VStack(alignment: .leading, spacing: 6) {
				HStack {
					 Text("Experiência")
						  .font(.subheadline)
						  .foregroundStyle(.secondary)
					 Spacer()
					 Text("\(Int(currentXP))/100")
						  .font(.subheadline.monospacedDigit())
						  .foregroundStyle(.secondary)
				}

				GeometryReader { geo in
					 ZStack(alignment: .leading) {
						  RoundedRectangle(cornerRadius: 999)
								.fill(Color.gray.opacity(0.2))

						  RoundedRectangle(cornerRadius: 999)
								.fill(LinearGradient(
									 colors: [.blue, .green],
									 startPoint: .leading,
									 endPoint: .trailing
								))
								.frame(width: geo.size.width * CGFloat(currentXP / 100.0))
								.animation(.easeInOut(duration: 0.4), value: currentXP)
					 }
				}
				.frame(height: 16)
		  }
	 }

	 // MARK: - Lógica

	 private func setupInitialState() {
		  currentLevel = initialLevel
		  currentXP = initialXP
		  remainingXP = gainedXP
		  isAnimating = true
	 }

	 private func startAnimation() async {
		  // Anima até consumir todo o XP ganho
		  while remainingXP > 0 {
				let spaceToLevelUp = 100 - currentXP

				if remainingXP >= spaceToLevelUp {
					 // 1) Enche até 100
					 await animateXP(to: 100)

					 // 2) "Level up"
					 await levelUp()

					 // 3) Desconta o que foi usado
					 remainingXP -= spaceToLevelUp
				} else {
					 // Apenas completar o restante, sem subir nível
					 let targetXP = currentXP + remainingXP
					 await animateXP(to: targetXP)
					 remainingXP = 0
				}
		  }

		  await MainActor.run {
				isAnimating = false
		  }
	 }

	 private func animateXP(to target: Double) async {
		  let clampedTarget = max(0, min(100, target))
		  let distance = abs(clampedTarget - currentXP)
		  // Duração proporcional à quantidade de XP animado
		  let duration = max(0.25, min(0.9, distance / 80.0))

		  await MainActor.run {
				withAnimation(.easeInOut(duration: duration)) {
					 currentXP = clampedTarget
				}
		  }

		  // Espera a animação terminar
		  try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
	 }

	 private func levelUp() async {
		  // Pequena pausa no 100 antes de subir o nível
		  try? await Task.sleep(nanoseconds: 300_000_000)

		  await MainActor.run {
				currentLevel += 1
				currentXP = 0
		  }

		  // Pequeno efeito de "respiro" antes de continuar
		  try? await Task.sleep(nanoseconds: 200_000_000)
	 }
}

#Preview {
	ExperienceGainContentView(
		initialLevel: 2,
		initialXP: 50,
		gainedXP: 120,
		onDismiss: {
			
		}
	)
}
