//
//  MockDataStore.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 27.03.2025.
//

import Foundation
@testable import EMToDo

final class MockDataStore: DataStoreDescription {
    
    var failingTests: Bool = false
    
    var tasks = [
        TodoTask(id: 1, title: "Mock", description: "Mock", completed: false),
        TodoTask(id: 2, title: "Mock 2", description: "Mock 2", completed: false),
        TodoTask(id: 3, title: "Mock 3", description: "Mock 3", completed: false),
        TodoTask(id: 4, title: "Mock 4", description: "Mock 4", completed: false),
    ]
    
    func fetchTasks(completion: @escaping (Result<[EMToDo.TodoTask], any Error>) -> Void) {
        if failingTests {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch tasks"])))
        } else {
            completion(.success(tasks))
        }
    }
    
    func removeTask(_ task: EMToDo.TodoTask, completion: @escaping (Result<Void, any Error>) -> Void) {
        tasks.removeAll { $0.id == task.id }
        if failingTests {
            completion(.failure(NSError(domain: "MockError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to remove task"])))
        } else {
            completion(.success(()))
        }
    }
    
    func toggleCompleted(_ task: EMToDo.TodoTask, completion: @escaping (Result<EMToDo.TodoTask, any Error>) -> Void) {
        guard let index = tasks.firstIndex(of: task) else {
            completion(.failure(NSError()))
            return
        }
        tasks[index].completed.toggle()
        completion(.success(tasks[index]))
    }
    
    func addNewTask(completion: @escaping (Result<EMToDo.TodoTask, any Error>) -> Void) {
        let newTask = TodoTask(id: tasks.count + 1, title: "New Mock Task", description: "", completed: false)
        tasks.append(newTask)
        completion(.success(newTask))
    }
    
    func editTask(_ task: EMToDo.TodoTask, title: String, content: String, completion: @escaping (Result<EMToDo.TodoTask, any Error>) -> Void) {
        guard let index = tasks.firstIndex(of: task), failingTests == false else {
            completion(.failure(NSError()))
            return
        }
        tasks[index] = task
        completion(.success(tasks[index]))
    }
}
