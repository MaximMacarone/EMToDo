//
//  MockTaskListPresenter.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 27.03.2025.
//

import Foundation
@testable import EMToDo

final class MockTaskListPresenterInteratorOutput: TaskListInteractorOutputDescription {
    var didFetchTasksCalled = false
    var didReceiveErrorCalled = false
    var didAddNewTaskCalled = false
    var didToggleCompletedCalled = false
    var didRemoveTaskCalled = false
    
    var newTask: TodoTask!
    var toggledTask: TodoTask!
    var fetchedTasks: [TodoTask]!
    var errorMessage: String!
    
    func didAddNewTask(_ task: EMToDo.TodoTask) {
        didAddNewTaskCalled = true
        newTask = task
    }
    
    func didRemoveTask() {
        didRemoveTaskCalled = true
    }
    
    func didFetchTasks(_ tasks: [EMToDo.TodoTask]) {
        didFetchTasksCalled = true
        fetchedTasks = tasks
    }
    
    func didReceiveError(_ message: String) {
        didReceiveErrorCalled = true
        errorMessage = message
    }
    
    func didToggleCompleted(_ task: EMToDo.TodoTask) {
        didToggleCompletedCalled = true
        toggledTask = task
    }
}
