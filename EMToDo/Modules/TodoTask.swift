//
//  TodoTask.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 25.03.2025.
//

import Foundation

struct TodoTask: Codable {
    let id: Int
    var title: String
    var description: String
    let createdAt: Date
    var completed: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case description = "todo"
        case completed
    }

    init(
        id: Int = UUID().hashValue,
        description: String = "",
        completed: Bool = false
    ) {
        self.id = id
        self.title = "Mock Title"
        self.description = description
        self.createdAt = Date()
        self.completed = completed
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        description = try container.decode(String.self, forKey: .description)
        completed = try container.decode(Bool.self, forKey: .completed)


        title = "Mock Title"
        createdAt = Date()
    }
}

struct TodoWrapper: Codable {
    let todos: [TodoTask]
}
