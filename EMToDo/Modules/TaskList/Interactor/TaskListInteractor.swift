//
//  TaskListInteractor.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 26.03.2025.
//

import CoreData

final class TaskListInteractor: TaskListInteractorInputDescription {
    
    //MARK: - VIPER
    
    var presenter: (any TaskListInteractorOutputDescription)?
    
    //MARK: - Properties
    
    private let dataStorage: DataStoreDescription
    
    init(dataStorage: DataStoreDescription) {
        self.dataStorage = dataStorage
    }

    //MARK: - Methods
    
    func fetchTasks() {
        dataStorage.fetchTasks { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tasks):
                self.presenter?.didFetchTasks(tasks)
            case .failure(let error):
                self.presenter?.didReceiveError(error.localizedDescription)
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
        dataStorage.removeTask(task) { [weak self] result in
            switch result {
            case .success():
                self?.presenter?.didRemoveTask()
            case .failure(let error):
                self?.presenter?.didReceiveError(error.localizedDescription)
            }
        }
    }
    
    func toggleCompleted(_ task: TodoTask) {
        dataStorage.toggleCompleted(task) { [weak self] result in
            switch result {
            case .success(let updatedTask):
                self?.presenter?.didToggleCompleted(updatedTask)
            case .failure(let error):
                self?.presenter?.didReceiveError(error.localizedDescription)
            }
        }
    }
    
    func addNewTask() {
        dataStorage.addNewTask { [weak self] result in
            switch result {
            case .success(let newTask):
                self?.presenter?.didAddNewTask(newTask)
            case .failure(let error):
                self?.presenter?.didReceiveError(error.localizedDescription)
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
