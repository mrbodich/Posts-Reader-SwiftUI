//
//  PostViewModel.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 17.07.2021.
//

import Combine
import SwiftUI

protocol PostViewModel: Identifiable {
    var authorCaption: String { get }
    var authorSubtitleCaption: String { get }
    var contentTitleCaption: String { get }
    var contentBodyCaption: String { get }
    
    var author: String { get }
    var authorSubtitle: String { get }
    var contentTitle: String { get }
    var contentBody: String { get }
}

struct StandardPostCellViewModel: PostViewModel {
    let id = UUID()
    
    var authorCaption = "Author"
    var authorSubtitleCaption = "Company"
    var contentTitleCaption = "Post Title"
    var contentBodyCaption = "Post"
    
    var author: String
    var authorSubtitle: String
    var contentTitle: String
    var contentBody: String
    
    init(for post: Post) {
        author = post.author
        authorSubtitle = post.company
        contentTitle = post.postTitle
        contentBody = post.postBody
    }
    
}
