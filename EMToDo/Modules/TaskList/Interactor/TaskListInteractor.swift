//
//  TaskListInteractor.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 26.03.2025.
//

import CoreData

final class TaskListInteractor: TaskListInteractroInputDescription {
    
    //MARK: - VIPER
    
    var presenter: (any TaskListInteractorOutputDescription)?

    //MARK: - Methods
    
    func fetchTasks() {
        CoreDataStack.shared.performBackgroundTask { [weak self] context in
            guard let self else { return }
            
            let fetchRequest: NSFetchRequest<LocalTodoTask> = LocalTodoTask.fetchRequest()
            
            do {
                let localTasks = try context.fetch(fetchRequest)
                if localTasks.isEmpty {
                    self.fetchTasksFromRemote()
                } else {
                    let tasks = localTasks.map { $0.toTodoTask() }
                    DispatchQueue.main.async {
                        self.presenter?.didFetchTasks(tasks)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                    self.presenter?.didReceiveError(error.localizedDescription)
                }
            }
        }
    }
    
    private func fetchTasksFromRemote() {
        APIService.shared.fetchTasks { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let tasks):
                self.saveTasksToLocal(tasks)
                DispatchQueue.main.async {
                    self.presenter?.didFetchTasks(tasks)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.didReceiveError(error.localizedDescription)
                }
            }
        }
    }
    
    func removeTask(_ task: TodoTask) {
        CoreDataStack.shared.performBackgroundTask { [weak self] context in
            guard let self else { return }
            let fetchRequest: NSFetchRequest<LocalTodoTask> = LocalTodoTask.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %lld", task.id)
            do {
                let results = try context.fetch(fetchRequest)
                if let localTask = results.first {
                    context.delete(localTask)
                    
                    try? context.save()
                    
                    DispatchQueue.main.async {
                        self.presenter?.didRemoveTask()
                    }
                }
            } catch {
                self.presenter?.didReceiveError(error.localizedDescription)
            }
        }
    }
    
    func toggleCompleted(_ task: TodoTask) {
        CoreDataStack.shared.performBackgroundTask { [weak self] context in
            guard let self else { return }
            
            let fetchRequest: NSFetchRequest<LocalTodoTask> = LocalTodoTask.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(task.id))
            
            do {
                let results = try context.fetch(fetchRequest)
                guard let localTask = results.first else {
                    return
                }

                localTask.completed.toggle()

                do {
                    try context.save()
                    
                    let updatedTask = localTask.toTodoTask()
                    
                    DispatchQueue.main.async {
                        self.presenter?.didToggleCompleted(updatedTask)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.presenter?.didReceiveError("Failed to save task update")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didReceiveError("Failed to fetch task")
                }
            }
        }
    }
    
    func addNewTask() {
        CoreDataStack.shared.performBackgroundTask { [weak self] context in
            guard let self else { return }
            
            let newLocalTask = LocalTodoTask(context: context)
            newLocalTask.id = Int64(UUID().hashValue)
            newLocalTask.title = "New task"
            newLocalTask.createdAt = Date()
            newLocalTask.content = ""
            newLocalTask.completed = false
            
            do {
                try context.save()
                
                let newTask = newLocalTask.toTodoTask()
                
                DispatchQueue.main.async {
                    self.presenter?.didAddNewTask(newTask)
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didReceiveError(error.localizedDescription)
                }
            }
        }
    }
    
    private func saveTasksToLocal(_ tasks: [TodoTask]) {
        CoreDataStack.shared.performBackgroundTask { context in
            for task in tasks {
                let localTask = LocalTodoTask(context: context)
                localTask.id = Int64(task.id)
                localTask.title = task.title
                localTask.createdAt = task.createdAt
                localTask.content = task.description
                localTask.completed = task.completed
            }
            try? context.save()
        }
    }
}
