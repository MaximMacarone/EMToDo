//
//  TaskDataStore.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 27.03.2025.
//

import Foundation
import CoreData

final class TaskDataStore: DataStoreDescription {
    private init() {
        if UserDefaults.standard.object(forKey: userDefaultsKey) == nil {
            needFetchFromAPI = true
        }
    }
    
    static let shared = TaskDataStore()
    
    private var apiService = APIService.shared
    
    private let userDefaultsKey = "needFetchFromAPI"
    
    private var needFetchFromAPI: Bool {
        get {
            UserDefaults.standard.bool(forKey: userDefaultsKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: userDefaultsKey)
        }
    }
    
    func fetchTasks(completion: @escaping (Result<[TodoTask], any Error>) -> Void) {
        if needFetchFromAPI {
            apiService.fetchTasks { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let tasks):
                    self.saveTasksToLocal(tasks) { success in
                        if success {
                            self.needFetchFromAPI = false
                            self.fetchTasksFromCoreData(completion: completion)
                        } else {
                            completion(.failure(NSError(domain: "CoreDataSaveError", code: 500, userInfo: nil)))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            fetchTasksFromCoreData(completion: completion)
        }
    }
    
    func removeTask(_ task: TodoTask, completion: @escaping (Result<Void, any Error>) -> Void) {
        CoreDataStack.shared.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<LocalTodoTask> = LocalTodoTask.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %lld", task.id)
            do {
                if let localTask = try context.fetch(fetchRequest).first {
                    context.delete(localTask)
                    try context.save()
                    completion(.success(()))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func toggleCompleted(_ task: TodoTask, completion: @escaping (Result<TodoTask, any Error>) -> Void) {
        CoreDataStack.shared.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<LocalTodoTask> = LocalTodoTask.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(task.id))
            do {
                if let localTask = try context.fetch(fetchRequest).first {
                    localTask.completed.toggle()
                    try context.save()
                    let updatedTask = localTask.toTodoTask()
                    completion(.success(updatedTask))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func addNewTask(completion: @escaping (Result<TodoTask, any Error>) -> Void) {
        CoreDataStack.shared.performBackgroundTask { context in
            let newLocalTask = LocalTodoTask(context: context)
            newLocalTask.id = Int64(UUID().hashValue)
            newLocalTask.title = "New task"
            newLocalTask.createdAt = Date()
            newLocalTask.content = ""
            newLocalTask.completed = false
            do {
                try context.save()
                let newTask = newLocalTask.toTodoTask()

                completion(.success(newTask))

            } catch {

                completion(.failure(error))

            }
        }
    }
    
    func editTask(_ task: TodoTask, title: String, content: String, completion: @escaping (Result<TodoTask, any Error>) -> Void) {
        CoreDataStack.shared.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<LocalTodoTask> = LocalTodoTask.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %lld", task.id)
            
            do {
                if let localTask = try context.fetch(fetchRequest).first {
                    localTask.title = title
                    localTask.content = content
                    try context.save()
                    let updatedTask = localTask.toTodoTask()
                    completion(.success(updatedTask))
                } else {
                    completion(.failure(NSError(domain: "TaskNotFoundError", code: 404, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func saveTasksToLocal(_ tasks: [TodoTask], completion: @escaping (Bool) -> Void) {
        CoreDataStack.shared.performBackgroundTask { context in
            do {
                for task in tasks {
                    let fetchRequest: NSFetchRequest<LocalTodoTask> = LocalTodoTask.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id == %lld", task.id)
                    
                    let existingTasks = try context.fetch(fetchRequest)
                    let localTask = existingTasks.first ?? LocalTodoTask(context: context)
                    
                    localTask.id = Int64(task.id)
                    localTask.title = task.title
                    localTask.createdAt = task.createdAt
                    localTask.content = task.description
                    localTask.completed = task.completed
                }
                try context.save()
                completion(true)
            } catch {
                completion(false)
            }
        }
    }
    
    private func fetchTasksFromCoreData(completion: @escaping (Result<[TodoTask], any Error>) -> Void) {
        CoreDataStack.shared.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<LocalTodoTask> = LocalTodoTask.fetchRequest()
            do {
                let localTasks = try context.fetch(fetchRequest)
                let tasks = localTasks.map { $0.toTodoTask() }
                completion(.success(tasks))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
