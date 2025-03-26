//
//  TaskListInteractorOutputDescription.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 25.03.2025.
//

protocol TaskListInteractorOutputDescription {
    func didAddNewTask()
    func didRemoveTask()
    func didFetchTasks(_ tasks: [TodoTask])
    func didReceiveError(_ message: String)
    func didToggleCompleted(_ task: TodoTask)
}
