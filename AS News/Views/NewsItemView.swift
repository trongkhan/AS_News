//
//  NewsItemView.swift
//  AS News
//
//  Created by Trọng Khang Hồ on 20/4/25.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    @State private var isLoading = true
    @State private var error: Error?
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
            parent.error = error
        }
    }
}

struct NewsItemView: View {
    let post: Post
    var body: some View {
        VStack {
            // Show web content if URL exists
            if let urlString = post.url,
               let url = URL(string: urlString) {
                WebView(url: url)
                    .edgesIgnoringSafeArea(.bottom)
            } else {
                // Fallback content when no URL is available
                Text("No web content available")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding()
                
                // Display post details as fallback
                VStack(alignment: .leading, spacing: 8) {
                    Text(post.title ?? "No title")
                        .font(.title)
                    
                    if let text = post.url {
                        Text(text)
                            .font(.body)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(post.title ?? "News Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}
