//
//  PostsListView.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 15.07.2021.
//

import SwiftUI
import Combine

struct PostsListView: View  {
    
    @ObservedObject var viewModel: StandardPostsListViewModel
    
    var body: some View {
        List(viewModel.posts) { post in
            Text(post.author)
//            print(post.author)
        }
        

    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostsListView()
//    }
//}
