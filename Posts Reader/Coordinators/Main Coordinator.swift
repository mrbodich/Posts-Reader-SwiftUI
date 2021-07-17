//
//  Coordinator.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 17.07.2021.
//

import SwiftUI

protocol Coordinator {
    
}

final class MainCoordinator<T: PostsListViewModel>: Coordinator, ObservableObject {
    
    var viewModel: T
    
    init(viewModel: T) {
        self.viewModel = viewModel
    }
    
}

struct MainCoordinatorView<T: PostsListViewModel>: View {
    
    var coordinator: MainCoordinator<T>
    
    var body: some View {
        PostsListView(viewModel: coordinator.viewModel)
    }
}


