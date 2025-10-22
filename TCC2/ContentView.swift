//
//  ContentView.swift
//  TCC2
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 19/10/25.
//

import SwiftUI

struct ContentView: View {
	
	@StateObject var profileViewModel = ProfileViewModel()
	
	var body: some View {
		NavigationStack {
			
			VStack {
				
			}
			
			.navigationTitle("Home")
		}
	}
}

#Preview {
	ContentView()
}
