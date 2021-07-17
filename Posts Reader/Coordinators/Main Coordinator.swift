//
//  Coordinator.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 17.07.2021.
//

import SwiftUI

protocol Coordinator {
    
}

class MainCoordinator: Coordinator, ObservableObject {
    
    private let postsService: PostsService
    var viewModel: StandardPostsListViewModel
    
    init(postsService: PostsService, listViewModel: StandardPostsListViewModel) {
        self.postsService = postsService
        self.viewModel = listViewModel
    }
    
}

struct MainCoordinatorView: View {
    
    var coordinator: MainCoordinator
    
    var body: some View {
        PostsListView(viewModel: coordinator.viewModel)
    }
}


