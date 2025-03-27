//
//  MockTaskListView.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 27.03.2025.
//

import Foundation
@testable import EMToDo


final class MockTaskListView: TaskListViewDescription {
    var presenter: (any EMToDo.TaskListPresenterDescription)?
    
    var tasks: [EMToDo.TodoTask] = []
    var tasksToManipulate: [EMToDo.TodoTask] = [
        TodoTask(id: 1, title: "Task 1", description: "", completed: false),
        TodoTask(id: 2, title: "Task 2", description: "", completed: true)
    ]
    var toggledTaskComplete: Bool?
    var errMsg: String?
    
    var didCallUpdateTasks: Bool = false
    var didCallToggleCompleted: Bool = false
    var didCallShowError: Bool = false
    
    func updateTasks(with tasks: [EMToDo.TodoTask]) {
        didCallUpdateTasks = true
        self.tasks = tasks
    }
    
    func toggleCompleted(_ task: EMToDo.TodoTask) {
        didCallToggleCompleted = true
        guard let index = self.tasksToManipulate.firstIndex(where: { $0.id == task.id }) else { return }
        tasksToManipulate[index] = task
        toggledTaskComplete = tasksToManipulate[index].completed
    }
    
    func showError(message: String) {
        didCallShowError = true
        self.errMsg = message
    }
}
