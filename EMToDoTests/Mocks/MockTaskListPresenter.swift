//
//  MockTaskListPresenter.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 28.03.2025.
//

import Foundation
@testable import EMToDo

final class MockTaskListPresenter: TaskListPresenterDescription {
    var interactor: (any EMToDo.TaskListInteractorInputDescription)?
    
    var router: (any EMToDo.TaskListRouterDescription)?
    
    var view: (any EMToDo.TaskListViewDescription)?
    
    var fetchTasksCalled: Bool = false
    var didSelectTaskCalled: Bool = false
    var deleteTaskCalled: Bool = false
    var addNewTaskCalled: Bool = false
    var toggleCompletedCalled: Bool = false
    
    var selectedTask: TodoTask?
    var taskToDelete: TodoTask?
    var taskToToggle: TodoTask?
    
    func didSelectTask(_ task: EMToDo.TodoTask) {
        didSelectTaskCalled = true
    }
    
    func addNewTask() {
        addNewTaskCalled = true
    }
    
    func deleteTask(_ task: EMToDo.TodoTask) {
        deleteTaskCalled = true
        taskToDelete = task
    }
    
    func toggleCompleted(_ task: EMToDo.TodoTask) {
        toggleCompletedCalled = true
        taskToToggle = task
    }
    
    func fetchTasks() {
        fetchTasksCalled = true
    }
}
