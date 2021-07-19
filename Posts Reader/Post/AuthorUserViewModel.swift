//
//  UserViewModel.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 19.07.2021.
//

import Foundation

protocol UserViewModel: ObservableObject {
    var isEmpty: Bool { get }
    var id: String { get }
    var name: String { get }
    var email: String { get }
    var address: Address { get }
    var phone: String { get }
    var company: Company { get }
}

class AuthorUserViewModel: UserViewModel {
    private var urlString = "https://source.unsplash.com/collection/542909/?sig="
    private let _urlString = "https://source.unsplash.com/collection/542909/?sig="
    
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
