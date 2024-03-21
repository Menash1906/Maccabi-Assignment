//
//  ContentView.swift
//  Maccabi-Assignment
//
//  Created by Michael Menashe on 19/03/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            CategoryListView()
                .navigationTitle("Categories")
        }
    }
}

#Preview {
    ContentView()
}
