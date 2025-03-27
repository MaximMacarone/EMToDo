//
//  DataStoreDescription.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 27.03.2025.
//

protocol DataStoreDescription {
    func fetchTasks(completion: @escaping (Result<[TodoTask], Error>) -> Void)
    func removeTask(_ task: TodoTask, completion: @escaping (Result<Void, Error>) -> Void)
    func toggleCompleted(_ task: TodoTask, completion: @escaping (Result<TodoTask, Error>) -> Void)
    func addNewTask(completion: @escaping (Result<TodoTask, Error>) -> Void)
    func editTask(_ task: TodoTask, title: String, content: String, completion: @escaping (Result<TodoTask, any Error>) -> Void)
}
