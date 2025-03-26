//
//  TaskListPresenter.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 26.03.2025.
//

final class TaskListPresenter: TaskListPresenterDescription {
    
    //MARK: - VIPER
    var interactor: (any TaskListInteractroInputDescription)?
    
    var router: (any TaskListRouterDescription)?
    
    var view: (any TaskListViewDescription)?
    
    //MARK: - Methods
    
    func didSelectTask(_ task: TodoTask) {
        guard let view else { return }
        
        router?.presentTaskDetail(on: view, for: task)
    }
    
    func addNewTask() {
        guard let view else { return }
        
        router?.presentTaskDetail(on: view, for: TodoTask())
    }
    
    func deleteTask(_ task: TodoTask) {
        interactor?.removeTask(task)
    }
    
    func toggleCompleted(_ task: TodoTask) {
        interactor?.toggleCompleted(task)
    }
    
    func fetchTasks() {
        interactor?.fetchTasks()
    }
}

extension TaskListPresenter: TaskListInteractorOutputDescription {
    func didAddNewTask() {
        interactor?.fetchTasksLocal()
    }
    
    func didRemoveTask() {
        interactor?.fetchTasksLocal()
    }
    
    func didFetchTasks(_ tasks: [TodoTask]) {
        view?.updateTableView(with: tasks)
    }
    
    func didReceiveError(_ message: String) {
        view?.showError(message: message)
    }
    
    func didToggleCompleted(_ task: TodoTask) {
        
    }
    
    
}
