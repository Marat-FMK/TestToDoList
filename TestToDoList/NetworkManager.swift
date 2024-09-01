//
//  NetworkManager.swift
//  TestToDoList
//
//  Created by Marat Fakhrizhanov on 31.08.2024.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    init() {}
    
    func fetchData(_ completion: @escaping(FakeTasks) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {  
            print("Invalid URL");return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print("No data")
                return
            }
            do {
                let fakeTasks = try JSONDecoder().decode(FakeTasks.self, from: data)
                DispatchQueue.main.async {
                    completion(fakeTasks)
                    print("Completion network")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
