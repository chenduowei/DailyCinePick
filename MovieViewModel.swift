//
//  MovieViewModel.swift
//  MovieRecommender
//
//  Created by chenduowei on 2023/4/7.
//

import SwiftUI
import Combine

struct MovieApiResponse: Decodable {
    let results: [Movie]
}

struct ListApiResponse: Decodable {
    let items: [Movie]
}

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []

    func fetchMoviesFromAPI(listID: Int) {
            let apiKey = "3b0d59cc5479510999bf0fc732e9dfe2"
            let urlString = "https://api.themoviedb.org/3/list/\(listID)?api_key=\(apiKey)&language=zh-CN"
            
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(ListApiResponse.self, from: data)
                        
                        DispatchQueue.main.async {
                            self.movies = Array(decodedResponse.items.prefix(5))
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                } else {
                    print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                }
            }.resume()
        }
}
