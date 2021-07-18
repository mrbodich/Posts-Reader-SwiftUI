//
//  PostsListView.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 15.07.2021.
//

import SwiftUI
import Combine

protocol ListView: View {
    associatedtype T: PostsListViewModel
    init(viewModel: T)
}

struct PostsListView<T: PostsListViewModel>: ListView {
    
    @ObservedObject private var viewModel: T
    @State private var isShowing = false
    
    init(viewModel: T) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List(viewModel.listItems) { post in
            
            ListCell(viewModel: post)
                .onNavigation {
                    viewModel.openPost(post)
                }
        }
        .onAppear {
            viewModel.loadItems()
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

struct ListCell: View {
    
    @ObservedObject var viewModel: PostDetailsViewModel
    
    init(viewModel: PostDetailsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        viewModel.loadUser()
        
        return VStack(alignment: .leading, spacing: nil) {
            Text("Author: \(viewModel.userViewModel.name)")
                .lineLimit(1)
            Text("Company: \(viewModel.userViewModel.company.name)")
                .lineLimit(1)
            Text("\(viewModel.contentTitle)")
                .lineLimit(1)
            Text("\(viewModel.contentBody)")
                .lineLimit(1)
        }
    }
}

