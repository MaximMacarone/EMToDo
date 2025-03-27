//
//  APIService.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 25.03.2025.
//

import Foundation

final class APIService: APIServiceDescription {
    private init() {}
    
    static let shared = APIService()
    var urlSession: URLSession = .shared
    
    func fetchTasks(completion: @escaping (Result<[TodoTask], APIError>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(.failure(.badURL))
            return
        }
        
        let dataTask = urlSession.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.fetchError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.badResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            do {
                let todoData = try JSONDecoder().decode(TodoWrapper.self, from: data)
                completion(.success(todoData.todos))
            } catch {
                completion(.failure(.badDecode))
            }
        }
        dataTask.resume()
    }
    
    
}
