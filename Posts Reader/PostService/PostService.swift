//
//  PostService.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 17.07.2021.
//

import Foundation

protocol PostsService {
    func fetchPosts(_ completionHandler: (_ posts: [Post]) -> ())
}

class TypicodePostsService: PostsService {
    
    func fetchPosts(_ completionHandler: ([Post]) -> ()) {
        
    }
    
}
