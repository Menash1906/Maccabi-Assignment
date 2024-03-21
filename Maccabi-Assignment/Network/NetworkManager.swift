//
//  NetworkManager.swift
//  Maccabi-Assignment
//
//  Created by Michael Menashe on 19/03/2024.
//

import SwiftUI

class NetworkManager {
    
    // Products endpoint url
    let endpoint = "https://dummyjson.com/products?limit=100"
    // Singleton
    static let shared = NetworkManager()
    private init() {}
    
    // MARK: Functions
    func getProducts() async throws -> [Product] {
        // Check url is valid
        guard let url = URL(string: endpoint) else { throw NetworkError.invalidUrl }
        
        let decoder = JSONDecoder()
        
        // Check for cache
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            // If cached, decode the cached data
            do {
                let allProducts = try decoder.decode(ProductsResponseModel.self, from: cachedResponse.data)
                return allProducts.products
            } catch {
                throw NetworkError.unknown
            }
        }
        
        // Fetch data from url
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Checking status code and error handling
        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.invalidUrl }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 429:
            throw NetworkError.tooManyRequests
        case 500:
            throw NetworkError.serverError
        default:
            throw NetworkError.unknown
        }
        
        // Cache the response
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
        
        // Decode products from ProductsResponseModel and return the products
        do {
            let allProducts = try decoder.decode(ProductsResponseModel.self, from: data)
            return allProducts.products
            
        } catch {
            throw NetworkError.unknown
        }
    }
}

// MARK: Errors
public enum NetworkError: LocalizedError {
    case invalidUrl
    case serverError
    case tooManyRequests
    case unknown
}

extension NetworkError {
    public var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Something went wrong"
        case .serverError:
            return "Bad connection to server"
        case .tooManyRequests:
            return "Too many requests, try again later"
        case .unknown:
            return "Unknown error, please try again"
        }
    }
}
