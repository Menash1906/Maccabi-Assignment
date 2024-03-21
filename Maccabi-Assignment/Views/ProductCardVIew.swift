//
//  ProductCardVIew.swift
//  Maccabi-Assignment
//
//  Created by Michael Menashe on 20/03/2024.
//

import SwiftUI

struct ProductCardVIew: View {
    
    let product: Product
    
    var body: some View {
        GroupBox(label: label) {
            content
            footer
        }
    }
}

#Preview {
    ProductCardVIew(product: Product(id: 1,
                                     title: "Sneakers",
                                     description: "",
                                     price: 0.99,
                                     discountPercentage: 12.0,
                                     rating: 3.5,
                                     stock: 5,
                                     brand: "Nike",
                                     category: "shoes",
                                     thumbnail: "",
                                     images: []))
}

extension ProductCardVIew {
    private var label: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                Text(product.brand)
                    .font(.caption)
                
                rating
            }
        }
    }
    
    private var content: some View {
        VStack {
            gallery
            description
        }
        .padding()
        
    }
    
    private var footer: some View {
        HStack {
            stock
            Spacer()
            price
        }
    }
    
    private var rating: some View {
        HStack(spacing: 0) {
            ForEach(0..<5) { star in
                Image(systemName: "star")
                    .symbolVariant(Int(product.rating) > star ? .fill : .none)
            }
            .foregroundStyle(.yellow)
            
            Text("\(product.rating.formatted())")
                .padding(.horizontal, 4)
        }
        .font(.caption2)
    }
    
    private var gallery: some View {
        TabView {
            ForEach(product.images, id:\.self) { image in
                AsyncImage(url: URL(string: image)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 128, height: 128)
                } placeholder: {
                    ProgressView()
                }
                .padding()
            }
        }
        .frame(minHeight: 128)
        .tabViewStyle(.page)
    }
    
    private var description: some View {
        Text(product.description)
            .font(.caption)
            .multilineTextAlignment(.leading)
    }
    
    private var stock: some View {
        Text(product.stock > 0 ? "Stock: \(product.stock)" : "Out of stock")
    }
    
    private var price: some View {
        VStack {
            HStack {
                Text("\(product.price.formatted()) $")
                    .font(.body)
                    .strikethrough()
                Text("-\(product.discountPercentage.formatted())%")
                    .foregroundStyle(.red)
                    .font(.caption)
                
            }
            
            Divider()
                .frame(maxWidth: 100)
            
            let discountedPrice = product.price - (product.price * product.discountPercentage / 100)
            
            Text("\(discountedPrice.formatted()) $")
                .font(.title3)
                .bold()
        }
    }
}
