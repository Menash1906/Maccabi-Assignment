//
//  ProductsViewModel.swift
//  Maccabi-Assignment
//
//  Created by Michael Menashe on 19/03/2024.
//

import Foundation

class ProductsViewModel: ObservableObject {
    
    @Published var products: [Product] = []
    @Published var error: NetworkError?
    
    lazy var categories: Set<String> = []
    
    // MARK: Functions
    func getProducts() async {
        do {
            // Fetch all products
            let prod = try await NetworkManager.shared.getProducts()
            DispatchQueue.main.async { [ weak self] in
                self?.products = prod
                
                // Mapping products titles that in wrong format
                let formattedProducts = prod.map { return $0.category }.sorted().map {
                    $0.contains("-") ?
                    $0.replacingOccurrences(of: "-", with: " ") : $0
                }
                
                self?.categories = Set(formattedProducts)
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.error = error as? NetworkError
            }
        }
    }
    
    func getCategoryInfoFromCategory(from category: String) -> Category {
        // Checks if category name in kebab-case
        let title = category.contains(" ") ?
        category.replacingOccurrences(of: " ", with: "-") : category
        
        // Get category inforamtion
        let numOfProd = getProductsCountFromCategory(from: title)
        let sumOfStock = getSumOfStockFromCategory(from: title)
        let thumbnail = getThumbnailfromCategory(from: title)
        
        return Category(name: category, thumbnail: thumbnail, numOfProd: numOfProd, sumOfStock: sumOfStock)
    }
    
    func getProductsFromCategory(from category: String) -> [Product] {
        // Checks if category name in kebab-case
        let title = category.contains(" ") ?
        category.replacingOccurrences(of: " ", with: "-") : category
        
        // Return filtered products from category
        return products.filter { $0.category == title }
    }
    
    // MARK: Private
    private func getProductsCountFromCategory(from category: String) -> Int {
        return products.filter { $0.category == category}.count
    }
    
    private func getThumbnailfromCategory(from category: String) -> String {
        // Get the thumbnail from the first product of the category
        guard let firstThumbnail = products.first(where: { $0.category == category })?.thumbnail else { return "" }
        return firstThumbnail
    }
    
    private func getSumOfStockFromCategory(from category: String) -> Int {
        // Get products from category
        let filteredProd = getProductsFromCategory(from: category)
        // Calc the total stock of the category
        let sumOfStock = filteredProd.reduce(0) { $0 + $1.stock }
        return sumOfStock
    }
}
