//
//  TaskDetailInteractor.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 26.03.2025.
//

final class TaskDetailInteractor: TaskDetailInteractorInputDescription {
    
    //MARK: - VIPER
    
    var presenter: (any TaskDetailPresenterDescription)?
    
    //MARK: - Properties
    
    var task: TodoTask?
    
    var todoTask: TodoTask?
    
    func fetchTask() -> TodoTask {
        guard let task else {
            fatalError("Failed to fetch task")
        }
        return task
    }
    
    func editTask(title: String, content: String) {
        
    }
    
    
}
