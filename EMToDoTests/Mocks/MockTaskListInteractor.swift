//
//  MockTaskListInteractor.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 27.03.2025.
//

import Foundation
@testable import EMToDo

final class MockTaskListInteractor: TaskListInteractorInputDescription {
    
    var didCallFetchTasks = false
    var didCallRemoveTask = false
    var didCallAddNewTask = false
    var didCallToggleCompleted = false
    
    var presenter: (any EMToDo.TaskListInteractorOutputDescription)?
    
    func fetchTasks() {
        didCallFetchTasks = true
        let tasks = [
            TodoTask(id: 1, title: "Test Task", description: "Test description", completed: false)
        ]
        presenter?.didFetchTasks(tasks)
    }
    
    func removeTask(_ task: EMToDo.TodoTask) {
        didCallRemoveTask = true
        presenter?.didRemoveTask()
    }
    
    func addNewTask() {
        didCallAddNewTask = true
        let newTask = TodoTask(id: 2, title: "New Task", description: "Description", completed: false)
        presenter?.didAddNewTask(newTask)
    }
    
    func toggleCompleted(_ task: EMToDo.TodoTask) {
        didCallToggleCompleted = true
        var toggledTask = task
        toggledTask.completed.toggle()
        presenter?.didToggleCompleted(toggledTask)
    }
}
