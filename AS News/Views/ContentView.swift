//
//  ContentView.swift
//  AS News
//
//  Created by Trọng Khang Hồ on 20/4/25.
//

import SwiftUI

struct PostRowView: View {
    @State var post: Post
    
    var formattedDate: String {
        guard let timestamp = post.createdAt else {
            return ""
        }
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(post.title ?? "Default title")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: 16) {
                if let author = post.author {
                    Text("by \(author)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let points = post.points {
                    Text("\(points) points")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                
                Text(formattedDate)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            if let url = post.url {
                Text(url)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 8)
    }
}
struct ListView: View {
    @StateObject private var viewModel = PostViewModel()
    
    var body: some View {
        NavigationView {
            List {
                if let error = viewModel.error {
                    ErrorView(error: error, retryAction: {
                        Task {
                            await viewModel.fetchPosts()
                        }
                    })
                } else {
                    ForEach(viewModel.posts) { post in
                        NavigationLink(destination: NewsItemView(post: post)){
                            PostRowView(post: post)
                        }
                    }
                }
            }
            .navigationTitle("ASAP News")
            .refreshable {
                await viewModel.fetchPosts()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
        }
        .task {
            if viewModel.posts.isEmpty {
                await viewModel.fetchPosts()
            }
        }
    }
}

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            VStack(spacing: 8) {
                Text("Error loading posts")
                    .font(.headline)
                Text(error.localizedDescription)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: retryAction) {
                Text("Retry")
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}
