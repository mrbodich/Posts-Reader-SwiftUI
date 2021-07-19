//
//  PostDetailsView.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 18.07.2021.
//

import SwiftUI

struct PostDetails<PostVM: PostViewModel>: View {
    
    @State private var isShowing = false
    
    @ObservedObject var viewModel: PostVM
    
    var body: some View {
        
        UIScrollViewWrapper {
            VStack {
                UserContainer(userViewModel: viewModel.userViewModel)
                PostContainer(postViewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.loadUser()
        }
        .pullToRefresh(isShowing: $isShowing) {
            viewModel.refreshUser()
            isShowing = false
        }
        .onChange(of: self.isShowing) { value in
        }
    }
}

struct UserContainer: View {
    
    @ObservedObject var userViewModel: AuthorUserViewModel
    
    init(userViewModel: AuthorUserViewModel) {
        self.userViewModel = userViewModel
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: nil) {
            AsyncImage(default: Image(systemName: "person.fill"), url: userViewModel.imageURL)
                .clipShape(Circle())
                .frame(width: 100, height: 100)
                .clipped()
            VStack(alignment: .leading, spacing: 4) {
                Text("Name: \(userViewModel.name)")
                Text("E-mail: \(userViewModel.email)")
                Text("Address: \(userViewModel.address.city), \(userViewModel.address.street), \(userViewModel.address.suite), \(userViewModel.address.zipcode)")
                    .lineLimit(5)
                    .frame(maxHeight: .infinity)
                Text("Phone: \(userViewModel.phone)")
                Text("Company: \(userViewModel.company.name)")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(maxHeight: .infinity)
        .padding(10)
    }
}

struct PostContainer<PostVM: PostViewModel>: View {
    @ObservedObject var postViewModel: PostVM
    
    init(postViewModel: PostVM) {
        self.postViewModel = postViewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: nil) {
            Text("\(postViewModel.contentTitle)")
                .fontWeight(.bold)
            Spacer()
            Text("\(postViewModel.contentBody)")
                .lineLimit(nil)
                .frame(maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(10)
    }
}

