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
                    DispatchQueue.main.async {
                        self.fetchTasksFromRemote()
                    }
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
                self.presenter?.didFetchTasks(tasks)
            case .failure(let error):
                self.presenter?.didReceiveError(error.localizedDescription)
            }
        }
    }
    
    func removeTask(_ task: TodoTask) {
        CoreDataStack.shared.performBackgroundTask { [weak self] context in
            guard let self else { return }
            let fetchRequest: NSFetchRequest<LocalTodoTask> = LocalTodoTask.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
            do {
                let results = try context.fetch(fetchRequest)
                if let localTask = results.first {
                    context.delete(localTask)
                    
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
            fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
            
            do {
                let results = try context.fetch(fetchRequest)
                if let localTask = results.first {
                    localTask.completed.toggle()
                    
                    DispatchQueue.main.async {
                        self.presenter?.didToggleCompleted(localTask.toTodoTask())
                    }
                }
            } catch {
                presenter?.didReceiveError(error.localizedDescription)
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
        }
    }
}
