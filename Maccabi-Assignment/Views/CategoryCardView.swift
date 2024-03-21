//
//  CategoryCardView.swift
//  Maccabi-Assignment
//
//  Created by Michael Menashe on 19/03/2024.
//

import SwiftUI

struct CategoryCardView: View {
    
    let category: Category
    
    var body: some View {
        
        GroupBox(category.name.capitalized) {
            HStack {
                thumbnail
                Spacer()
                info
            }
            .padding()
        }
    }
}

#Preview {
    CategoryCardView(category: Category(name: "Test",
                                        thumbnail: "",
                                        numOfProd: 0,
                                        sumOfStock: 0))
}

extension CategoryCardView {
    private var info: some View {
        VStack(alignment: .leading) {
            Text("Products: \(category.numOfProd)")
                .font(.subheadline)
                .bold()
            Text("Stock: \(category.sumOfStock)")
                .font(.subheadline)
                .bold()
        }
    }
    
    private var thumbnail: some View {
        AsyncImage(url: URL(string: category.thumbnail)) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: 128, height: 128)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } placeholder: {
            ProgressView()
                .frame(width: 128, height: 128)
        }
    }
}
