//
//  PostsListViewModel.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 17.07.2021.
//

import Combine
import SwiftUI

protocol PostsListViewModel: ObservableObject {
    var listItems: [PostDetailsViewModel] { get }
    func updateItems(_ onCompletion: @escaping () -> ())
    func loadItems()
    func openPost(_ postViewModel: PostDetailsViewModel)
}

final class StandardPostsListViewModel: PostsListViewModel, ObservableObject {
    typealias Coordinator = PostListCoordinator
    
    var posts: [Post] = [] {
        didSet {
            DispatchQueue.main.async { [self] in
                self.listItems = posts.map {
                    PostDetailsViewModel(for: $0, coordinator: coordinator, postsService: postsService)
                }
            }
        }
    }
    @Published var listItems: [PostDetailsViewModel] = []
    private let postsService: PostsFetchingService
    unowned var coordinator: Coordinator
    
    init(postsService: PostsFetchingService, coordinator: Coordinator) {
        self.postsService = postsService
        self.coordinator = coordinator
    }
    
    func updateItems(_ onCompletion: @escaping () -> ()) {
        postsService.fetchPosts { posts in
            self.posts = posts
            onCompletion()
        }
    }
    
    func loadItems() {
        if posts.count == 0 {
            updateItems { }
        }
    }
    
    func openPost(_ postViewModel: PostDetailsViewModel) {
        coordinator.open(postViewModel)
    }
}
