//
//  PostViewModel.swift
//  AS News
//
//  Created by Trọng Khang Hồ on 20/4/25.
//

import Foundation
@MainActor
class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var error: Error?
    @Published var isLoading = false
    
    private let baseURL = "https://hn.algolia.com/api/v1/search?tags=story"
    
    func fetchPosts() async {
        isLoading = true
        error = nil
        
        guard let url = URL(string: baseURL) else {
            error = URLError(.badURL)
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(HNResponse.self, from: data)
            
            posts = response.hits // Already on main thread
            isLoading = false
            
        } catch {
            self.error = error
            self.isLoading = false
        }
    }
}
