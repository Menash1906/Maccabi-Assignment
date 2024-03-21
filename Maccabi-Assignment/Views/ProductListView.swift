//
//  ProductListView.swift
//  Maccabi-Assignment
//
//  Created by Michael Menashe on 20/03/2024.
//

import SwiftUI

struct ProductListView: View {
    let category: String
    @EnvironmentObject var vm: ProductsViewModel
    
    var body: some View {
        List(vm.getProductsFromCategory(from: category), id:\.id) { product in
            ProductCardVIew(product: product)
        }
        .navigationTitle(category.capitalized)
        .listStyle(.plain)
    }
}

#Preview {
    ProductListView(category: "")
}
