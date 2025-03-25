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
    
    func fetchTasks(completion: @escaping (Result<[Task], APIError>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(.failure(.badURL))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.fetchError(error.localizedDescription)))
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
