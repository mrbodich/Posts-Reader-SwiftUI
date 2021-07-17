//
//  PostsListViewModel.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 17.07.2021.
//

import Combine
import SwiftUI

protocol PostsListViewModel: ObservableObject {
    var listItems: [StandardPostCellViewModel] { get }
    func updateItems(_ onCompletion: @escaping () -> ())
    func updateItems()
}

final class StandardPostsListViewModel: PostsListViewModel {
    @Published var listItems: [StandardPostCellViewModel] = []
    private let postsService: PostsFetchingService
    
    init(postsService: PostsFetchingService) {
        self.postsService = postsService
    }
    
    func updateItems(_ onCompletion: @escaping () -> ()) {
        postsService.fetchPosts { posts in
            self.listItems = posts.map {
                StandardPostCellViewModel(for: $0)
            }
            onCompletion()
        }
    }
    
    func updateItems() {
        updateItems { }
    }
}
