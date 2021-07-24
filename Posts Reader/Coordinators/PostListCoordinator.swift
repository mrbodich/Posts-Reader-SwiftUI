//
//  Coordinator.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 17.07.2021.
//

import SwiftUI

protocol Coordinator {
    
}

final class PostListCoordinator: Coordinator, ObservableObject {
    
    var viewModel: StandardPostsListViewModel!
    @Published var detailViewModel: PostDetailsViewModel?
    let postsService: PostsFetchingService
    
    init(postsService: PostsFetchingService) {
        self.postsService = postsService
        self.viewModel = StandardPostsListViewModel(postsService: postsService, coordinator: self)
    }
    
    func open(_ post: PostDetailsViewModel) {
        self.detailViewModel = post
    }
    
}

struct PostListCoordinatorView: View {
    
    @ObservedObject var coordinator: PostListCoordinator
    
    var body: some View {
        NavigationView {
            PostsListView(viewModel: coordinator.viewModel)
                .navigationBarTitle("Posts Feed", displayMode: .inline)
                .navigation(item: $coordinator.detailViewModel) { details in
                    PostDetails(viewModel: details.eraseToAnyPostViewModel())
                }
        }
        
    }
}
