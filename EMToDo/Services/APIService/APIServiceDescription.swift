//
//  APIServiceDescription.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 25.03.2025.
//

enum APIError: Error {
    case badURL
    case fetchError(String)
    case badResponse
    case badData
    case badDecode
}

protocol APIServiceDescription {
    func fetchTasks(completion: @escaping (Result<[TodoTask], APIError>) -> Void)
    
}
