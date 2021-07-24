//
//  PostViewModel.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 17.07.2021.
//

import Combine
import SwiftUI

protocol PostViewModel: ObservableObject, Identifiable {
    var contentTitle: String { get }
    var contentBody: String { get }
    var id: Int { get }
    
    var userViewModel: AuthorUserViewModel { get }
    func refreshUser()
    func loadUser()
}

class AnyPostViewModel: PostViewModel {
    var contentTitle: String
    var contentBody: String
    var id: Int
    @ObservedObject var userViewModel: AuthorUserViewModel
    
    var _refreshUser: () -> ()
    func refreshUser() {
        _refreshUser()
    }
    
    var _loadUser: () -> ()
    func loadUser() {
        _loadUser()
    }
    
    let objectWillChange: AnyPublisher<Void, Never>
    
    init<ViewModel: PostViewModel>(wrapping viewModel: ViewModel) {
        objectWillChange = viewModel.objectWillChange.map({ _ in }).eraseToAnyPublisher()
        contentTitle = viewModel.contentTitle
        contentBody = viewModel.contentBody
        id = viewModel.id
        userViewModel = viewModel.userViewModel
        _refreshUser = viewModel.refreshUser
        _loadUser = viewModel.loadUser
    }
}

extension PostViewModel {
    func eraseToAnyPostViewModel() -> AnyPostViewModel {
        return AnyPostViewModel(wrapping: self)
    }
}

class PostDetailsViewModel: PostViewModel {
    
    private let post: Post
    private var user: User?
    private unowned let coordinator: PostListCoordinator
    private let postsService: PostsFetchingService
    
    var contentTitle: String { post.title }
    var contentBody: String { post.body }
    var id: Int { post.id }
    
    @ObservedObject var userViewModel: AuthorUserViewModel

    init(for post: Post, coordinator: PostListCoordinator, postsService: PostsFetchingService) {
        self.coordinator = coordinator
        self.post = post
        self.postsService = postsService
        self.userViewModel = AuthorUserViewModel(id: post.id)
    }
    
    var isUserLoading = false
    func loadUser() {
        if userViewModel.isEmpty, !isUserLoading {
            refreshUser()
        }
    }
    
    func refreshUser() {
        isUserLoading = true
        postsService.fetchUser(withID: post.userId) { user in
            DispatchQueue.main.async {
                self.updateState(with: user)
                self.isUserLoading = false
            }
        }
    }
    
    func updateState(with user: User) {
        userViewModel = AuthorUserViewModel(user: user)
        self.objectWillChange.send()
    }
}


