//
//  Post.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 17.07.2021.
//

import Foundation

struct Post: Identifiable, Decodable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
