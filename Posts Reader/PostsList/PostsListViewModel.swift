//
//  PostsListViewModel.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 17.07.2021.
//

import Combine
import SwiftUI

protocol PostsListViewModel {
    var posts: [StandardPostCellViewModel] { get set }
    func updatePosts()
}

class StandardPostsListViewModel: PostsListViewModel, ObservableObject {
    
    private let postsService: PostsService
    
    init(postsService: PostsService) {
        self.postsService = postsService
    }
    
    @Published var posts: [StandardPostCellViewModel] = []
    
    func updatePosts() {
        postsService.fetchPosts { [weak self] posts in
            self?.posts = posts.map { StandardPostCellViewModel(for: $0) }
        }
    }
    
}
