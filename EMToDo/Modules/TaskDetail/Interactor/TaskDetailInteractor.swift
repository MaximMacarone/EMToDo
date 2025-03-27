//
//  TaskDetailInteractor.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 26.03.2025.
//

import CoreData

final class TaskDetailInteractor: TaskDetailInteractorInputDescription {
    
    //MARK: - VIPER
    
    var presenter: (any TaskDetailInteractorOutputDescription)?
    
    //MARK: - Properties
    
    var task: TodoTask?
    
    var todoTask: TodoTask?
    
    private let dataStore: DataStoreDescription
    
    //MARK: - Init
    
    init(dataStore: DataStoreDescription) {
        self.dataStore = dataStore
    }
    
    //MARK: - Methods
    
    func fetchTask() -> TodoTask {
        guard let task else {
            fatalError("Failed to fetch task")
        }
        return task
    }
    
    func editTask(title: String, content: String) {
        
        dataStore.editTask(task!, title: title, content: content) { [weak self] result in
            switch result {
            case .success(let updatedTask):
                self?.task = updatedTask
                self?.presenter?.didEditTask()
            case .failure(_):
                self?.presenter?.didFailToEditTask()
            }
        }
    }
}
