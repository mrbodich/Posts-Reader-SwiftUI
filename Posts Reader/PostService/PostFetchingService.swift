//
//  PostService.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 17.07.2021.
//

import Foundation

protocol PostsFetchingService {
    func fetchPosts(_ completionHandler: @escaping (_ posts: [Post]) -> ())
    func fetchUser(withID id: Int, _ completionHandler: @escaping (User) -> ())
}

final class MockPostsFetchingService: PostsFetchingService {
    private let queue = DispatchQueue(label: "com.MockPostsFetchingService", qos: .background, attributes: .concurrent)
    private let semaphore = DispatchSemaphore(value: 10)
    
    func fetchPosts(_ completionHandler: @escaping ([Post]) -> ()) {
        var posts: [Post] = []
        for index in 1...40 {
            posts.append(Post(id: index,
                              userId: 1,
                              title: "Post title title title title title title title title title title title title title title \(index)",
                              body: "Body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body random \(Int.random(in: 1...100))"))
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            completionHandler(posts)
        }
    }
    
    func fetchUser(withID id: Int, _ completionHandler: @escaping (User) -> ()) {
        queue.async {
            self.semaphore.wait()
            let address = Address(street: "Main St. with long long long long long long name",
                                  suite: "11",
                                  city: "Washington",
                                  zipcode: "007")
            let company = Company(name: "The Best Company LLC")
            let user = User(id: id,
                            name: "John \(Int.random(in: 0...1000))",
                            email: "john.test@gmail.com",
                            address: address,
                            phone: "+1997777777",
                            company: company)
            
            
            DispatchQueue.main.async {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.semaphore.signal()
                    completionHandler(user)
                }
            }
        }
    }
    
}

final class NetworkPostsFetchingService: PostsFetchingService {
    private let postsURL = "https://jsonplaceholder.typicode.com/posts"
    private let userURL = "https://jsonplaceholder.typicode.com/users/"
    
    private let queue = DispatchQueue(label: "com.MockPostsFetchingService", qos: .background, attributes: .concurrent)
    private let semaphore = DispatchSemaphore(value: 10)
    
    func fetchPosts(_ completionHandler: @escaping ([Post]) -> ()) {
        guard let url = URL(string: postsURL) else { return }
        let request = URLRequest(url: url)
        let urlSession = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("‼️ Fetching posts failed with error: \(error.localizedDescription)")
                return
            }
            let decoder = JSONDecoder()
            guard let data = data, let fetchedPosts = try? decoder.decode([Post].self, from: data) else {
                print("‼️ Decoding posts from JSON failed")
                return
            }
            
            completionHandler(fetchedPosts)
        }
        urlSession.resume()
    }
    
    func fetchUser(withID id: Int, _ completionHandler: @escaping (User) -> ()) {
        queue.async { [self] in
            self.semaphore.wait()

            guard let url = URL(string: "\(userURL)\(id)") else { return }
            let request = URLRequest(url: url)
            let urlSession = URLSession.shared.dataTask(with: request) { data, response, error in
                self.semaphore.signal()
                if let error = error {
                    print("‼️ Fetching User failed with error: \(error.localizedDescription)")
                    return
                }
                let decoder = JSONDecoder()
                guard let data = data, let fetchedUser = try? decoder.decode(User.self, from: data) else {
                    print("‼️ Decoding User from JSON failed")
                    return
                }
                
                completionHandler(fetchedUser)
            }
            urlSession.resume()
            
        }
    }
    
}
