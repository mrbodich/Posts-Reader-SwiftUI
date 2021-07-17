//
//  Post.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 17.07.2021.
//

import Foundation

extension Identifiable where ID: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Post: Identifiable {
    let id = UUID()
    
    let author: String
    let company: String
    let postTitle: String
    let postBody: String
}
