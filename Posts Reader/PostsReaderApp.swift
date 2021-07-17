//
//  Posts_ReaderApp.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 15.07.2021.
//

import SwiftUI

@main
struct PostsReaderApp: App {
    
    @StateObject var mainCoordinator = MainCoordinator(postsService: TypicodePostsService(), listViewModel: StandardPostsListViewModel(postsService: TypicodePostsService()))
    
    var body: some Scene {
        WindowGroup {
            MainCoordinatorView(coordinator: mainCoordinator)
        }
    }
}
