//
//  Carousel.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 28/10/25.
//

import SwiftUI

struct Carousel<Item: Identifiable & Hashable, Content: View>: View {
	let items: [Item]
	@Binding var selection: Item.ID?
	let cardWidth: CGFloat
	let spacing: CGFloat
	@ViewBuilder var content: (Item) -> Content
	
	init(items: [Item],
		  selection: Binding<Item.ID?>,
		  cardWidth: CGFloat = 260,
		  spacing: CGFloat = 16,
		  @ViewBuilder content: @escaping (Item) -> Content) {
		self.items = items
		self._selection = selection
		self.cardWidth = cardWidth
		self.spacing = spacing
		self.content = content
	}
	
	var body: some View {
		GeometryReader { geo in
			let side = max(0, (geo.size.width - cardWidth) / 2) // margem p/ centralizar
			
			ScrollView(.horizontal) {
				LazyHStack(spacing: spacing) {
					ForEach(items) { item in
						content(item)
							.frame(width: cardWidth)
						// efeito no item central
							.containerRelativeFrame(.horizontal, alignment: .center)
							.scrollTransition(.interactive, axis: .horizontal) { view, phase in
								view
									.scaleEffect(phase.isIdentity ? 1.0 : 0.94)
									.opacity(phase.isIdentity ? 1.0 : 0.85)
							}
							.id(item.id) // importante p/ snapping por ID
					}
				}
				.scrollTargetLayout() // alvos de snap são os itens
			}
			.scrollIndicators(.hidden)
			.contentMargins(.horizontal, side, for: .scrollContent)
			.scrollTargetBehavior(.viewAligned) // SNAP ao centro
			.scrollPosition(id: $selection) // controle do item selecionado
			.onAppear {
				// Seleção inicial (se não estiver setada)
				if let current = selection, items.contains(where: { $0.id == current }) {
					// keep current selection
				} else {
					selection = items.first?.id
				}
			}
		}
		.frame(height: 240) // ajuste conforme o card
	}
}

#Preview {
	@Previewable @State var selectedID: ArchLevel.ID? // controla o snap/seleção
	let items: [ArchLevel] = [
		.init(title: "MVC", subtitle: "Camadas básicas"),
		.init(title: "MVVM", subtitle: "Estado reativo"),
		.init(title: "VIPER", subtitle: "Use Cases + Router"),
		.init(title: "Clean", subtitle: "Domínio puro")
	]

	Carousel(items: items, selection: $selectedID) { item in
		ArchitectureLevelCard(title: item.title, subtitle: item.subtitle)
			.clipShape(RoundedRectangle(cornerRadius: 20))
			.shadow(radius: 6)
			.onTapGesture {
				print(item.title)
			}
	}
}
