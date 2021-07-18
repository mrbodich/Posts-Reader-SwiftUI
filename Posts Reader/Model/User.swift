//
//  User.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 18.07.2021.
//

import Foundation

struct User: Decodable {
    let id: Int
    let name: String
    let email: String
    let address: Address
    let phone: String
    let company: Company
}

struct Address: Decodable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
}

struct Company: Decodable {
    let name: String
}
