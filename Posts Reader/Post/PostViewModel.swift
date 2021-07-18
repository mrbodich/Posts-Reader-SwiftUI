//
//  PostViewModel.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 17.07.2021.
//

import Combine
import SwiftUI

protocol PostViewModel {
    var contentTitle: String { get }
    var contentBody: String { get }
    var id: Int { get }
    
    var userViewModel: UserViewModel { get }
    func refreshUser()
}

class PostDetailsViewModel: Identifiable, PostViewModel, ObservableObject {
    
    private let post: Post
    private var user: User?
    private unowned let coordinator: PostListCoordinator
    private let postsService: PostsFetchingService
    
    var contentTitle: String { post.title }
    var contentBody: String { post.body }
    var id: Int { post.id }
    
    @ObservedObject var userViewModel: UserViewModel

    init(for post: Post, coordinator: PostListCoordinator, postsService: PostsFetchingService) {
        self.coordinator = coordinator
        self.post = post
        self.postsService = postsService
        self.userViewModel = UserViewModel(id: post.id)
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
        userViewModel = UserViewModel(user: user)
        self.objectWillChange.send()
    }
}

class UserViewModel: ObservableObject {
    var urlString = "https://source.unsplash.com/collection/542909/?sig="
    let _urlString = "https://source.unsplash.com/collection/542909/?sig="
    
    let isEmpty: Bool
    let uuid = UUID()
    let id: String
    let name: String
    let email: String
    let address: Address
    let phone: String
    let company: Company
    
    var imageURL: URL? {
        URL(string: urlString + id)
    }
    
    init(id: Int) {
        self.id = "\(id)"
        name = ""
        email = ""
        address = Address(street: "", suite: "", city: "", zipcode: "")
        phone = ""
        company = Company(name: "")
        isEmpty = true
    }
    
    init(user: User) {
        urlString = _urlString + "\(Int.random(in: 0...100000))" //It allow to update the image each time we do Pull-To-Update on the Details screen
        id = "\(user.id)"
        name = user.name
        email = user.email
        address = user.address
        phone = user.phone
        company = user.company
        isEmpty = false
    }
}
