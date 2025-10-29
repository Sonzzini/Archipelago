//
//  CodeSnippetView.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 28/10/25.
//

import SwiftUI

import SwiftUI

/// CodeSnippetView: bloco de código com botão "Copy"
struct CodeSnippetView: View {
	// Conteúdo
	let title: String?
	let code: String
	let language: String?
	
	// Aparência
	let showLineNumbers: Bool
	let lineWrap: Bool
	let cornerRadius: CGFloat
	let padding: CGFloat
	
	// Estado
	@State private var copied = false
	
	init(title: String? = nil,
		  code: String,
		  language: String? = nil,
		  showLineNumbers: Bool = true,
		  lineWrap: Bool = false,
		  cornerRadius: CGFloat = 14,
		  padding: CGFloat = 14) {
		self.title = title
		self.code = code
		self.language = language
		self.showLineNumbers = showLineNumbers
		self.lineWrap = lineWrap
		self.cornerRadius = cornerRadius
		self.padding = padding
	}
	
	var body: some View {
		VStack(spacing: 8) {
			// Header
			HStack(spacing: 8) {
				if let title {
					Text(title)
						.font(.headline)
				}
				if let language, !language.isEmpty {
					Text(language.uppercased())
						.font(.caption2)
						.padding(.horizontal, 8)
						.padding(.vertical, 4)
						.background(.ultraThinMaterial, in: Capsule())
				}
				Text("Esta é uma representação do cenário, não uma solução funcional.")
					.font(.footnote)
					.foregroundStyle(.secondary)
				Spacer()
				Button(action: copyToClipboard) {
					Label(copied ? "Copied" : "Copy",
							systemImage: copied ? "checkmark.circle.fill" : "doc.on.doc")
					.labelStyle(.titleAndIcon)
				}
				.buttonStyle(.bordered)
			}
			
			// Corpo do snippet
			Group {
				if showLineNumbers {
					snippetWithLineNumbers
				} else {
					snippetPlain
				}
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.background(
				RoundedRectangle(cornerRadius: cornerRadius)
					.fill(Color(.secondarySystemBackground))
			)
			.overlay(
				RoundedRectangle(cornerRadius: cornerRadius)
					.stroke(Color.secondary.opacity(0.25), lineWidth: 1)
			)
		}
		.padding(padding)
		.background(
			RoundedRectangle(cornerRadius: cornerRadius + 4)
				.fill(.thinMaterial)
		)
		.clipShape(RoundedRectangle(cornerRadius: cornerRadius + 4))
	}
	
	// MARK: - Views
	
	private var snippetPlain: some View {
		ScrollView([.vertical, lineWrap ? [] : .horizontal]) {
			Text(code)
				.font(.system(.body, design: .monospaced))
				.textSelection(.enabled)
				.lineLimit(lineWrap ? nil : 1)
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(12)
		}
	}
	
	private var snippetWithLineNumbers: some View {
		let lines = code.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
		return ScrollView([.vertical, lineWrap ? [] : .horizontal]) {
			HStack(alignment: .top, spacing: 12) {
				// Coluna de números
				VStack(alignment: .trailing, spacing: 4) {
					ForEach(lines.indices, id: \.self) { i in
						Text("\(i + 1)")
							.font(.system(.body, design: .monospaced))
							.foregroundStyle(.secondary)
							.frame(maxWidth: .infinity, alignment: .trailing)
					}
				}
				.padding(.vertical, 12)
				.padding(.leading, 12)
				.background(Color.black.opacity(0.04))
				.clipShape(RoundedRectangle(cornerRadius: 8))
				
				// Coluna do código
				VStack(alignment: .leading, spacing: 4) {
					ForEach(lines, id: \.self) { line in
						Text(line.isEmpty ? " " : line)
							.font(.system(.body, design: .monospaced))
							.textSelection(.enabled)
							.lineLimit(lineWrap ? nil : 1)
							.frame(maxWidth: .infinity, alignment: .leading)
					}
				}
				.padding(.vertical, 12)
				.padding(.trailing, 12)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
		}
	}
	
	// MARK: - Copy
	
	private func copyToClipboard() {
#if os(iOS)
		UIPasteboard.general.string = code
		UIImpactFeedbackGenerator(style: .light).impactOccurred()
#elseif os(macOS)
		let pb = NSPasteboard.general
		pb.clearContents()
		pb.setString(code, forType: .string)
#endif
		
		withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
			copied = true
		}
		// Volta ao estado "Copy" após 1.5s
		Task { @MainActor in
			try? await Task.sleep(nanoseconds: 1_500_000_000)
			withAnimation(.easeOut) { copied = false }
		}
	}
}

#Preview {
	CodeSnippetView(code: """
struct ArchitectureLevelCard: View {
 var title: String
 var subtitle: String
 var body: some View {
  VStack {
	Text(title).font(.title2).bold()
	Text(subtitle).foregroundStyle(.secondary)
  }
  .padding()
 }
}
""")
}
