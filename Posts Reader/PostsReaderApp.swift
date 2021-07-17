//
//  Posts_ReaderApp.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 15.07.2021.
//

import SwiftUI

@main
struct PostsReaderApp: App {
    
//    @StateObject var mainCoordinator: MainCoordinator<StandardPostsListViewModel>
    @StateObject var mainCoordinator = MainCoordinator(viewModel: StandardPostsListViewModel(postsService: MockPostsFetchingService()))
    
//    init() {
//        let postService = TypicodePostsService()
//        mainCoordinator = MainCoordinator(postsService: TypicodePostsService(),
//                                          viewModel: StandardPostsListViewModel(postsService: postService))
//    }
    
    var body: some Scene {
        WindowGroup {
//            PullToRefreshDemo()
            MainCoordinatorView(coordinator: mainCoordinator)
        }
    }
}
