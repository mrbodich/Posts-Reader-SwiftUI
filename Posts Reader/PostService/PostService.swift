//
//  PostService.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 17.07.2021.
//

import Foundation

protocol PostsFetchingService {
    func fetchPosts(_ completionHandler: @escaping (_ posts: [Post]) -> ())
}

class MockPostsFetchingService: PostsFetchingService {
    
    func fetchPosts(_ completionHandler: @escaping ([Post]) -> ()) {
        var posts: [Post] = []
        for index in 1...40 {
            posts.append(Post(author: "author \(index)", company: "company \(index)", postTitle: "Post \(index)", postBody: "Body random \(Int.random(in: 1...100))"))
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            completionHandler(posts)
        }
    }
    
}
