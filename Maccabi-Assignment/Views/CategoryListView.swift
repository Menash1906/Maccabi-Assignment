//
//  CategoryListView.swift
//  Maccabi-Assignment
//
//  Created by Michael Menashe on 20/03/2024.
//

import SwiftUI

struct CategoryListView: View {
    
    @StateObject private var vm = ProductsViewModel()
    
    var body: some View {
        
        List(Array(vm.categories), id: \.self) { category in
            NavigationLink(value: category) {
                CategoryCardView(category: vm.getCategoryInfoFromCategory(from: category))
            }
        }
        .listStyle(.plain)
        .task {
            guard vm.products.isEmpty else { return }
            await vm.getProducts()
        }
        .navigationDestination(for: String.self) { category  in
            ProductListView(category: category)
                .environmentObject(vm)
        }
        .navigationTitle("Categories")
        // Error alert
        .alert(isPresented: .constant(vm.error != nil), error: vm.error) {
            switch vm.error {
            case .invalidUrl, .serverError, .unknown:
                Button("Try again") {
                    Task {
                        await vm.getProducts()
                    }
                }
            case .tooManyRequests:
                Button("Try again later") { }
            case .none:
                EmptyView()
            }
        }
    }
}

#Preview {
    CategoryListView()
}
