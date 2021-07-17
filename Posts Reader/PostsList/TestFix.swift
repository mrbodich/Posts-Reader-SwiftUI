//
//  TestFix.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 17.07.2021.
//

import SwiftUI
import Combine

struct RecipeList: View {

    // MARK: Stored Properties

    @ObservedObject var viewModel: RecipeListViewModel

    // MARK: Views

    var body: some View {
        List(viewModel.recipes) { recipe in
            
        }
    }

}

class RecipeListViewModel: ObservableObject {

    // MARK: Stored Properties

    @Published var title: String
    @Published var recipes = [Recipe]()


    // MARK: Initialization

    init(title: String,
         filter: @escaping (Recipe) -> Bool) {
        self.title = title

    }


}

struct Recipe: Identifiable {

    // MARK: Stored Properties

    var id = UUID()
    var imageURL: URL?
    var title: String
    var ingredients: [String]
    var steps: [String]
    var isVegetarian: Bool
    var source: URL?

}
