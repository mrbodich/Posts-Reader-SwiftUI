//
//  PostsListView.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 15.07.2021.
//

import SwiftUI
import Combine

struct PostsListView<T>: View where T: PostsListViewModel {
    
    @ObservedObject private var viewModel: T
    @State private var isShowing = false
    
    init(viewModel: T) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.listItems) { post in
                Text("\(post.author)  \(post.contentBody)")
            }
            .onAppear {
                viewModel.updateItems()
            }
            .pullToRefresh(isShowing: $isShowing) {
                viewModel.updateItems() {
                    DispatchQueue.main.async {
                        self.isShowing = false
                    }
                }
            }
            .onChange(of: self.isShowing) { value in
            }
        }

    }
}



