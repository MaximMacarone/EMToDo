//
//  TaskListViewDescription.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 25.03.2025.
//

protocol TaskListViewDescription: AnyObject {
    var presenter: TaskListPresenterDescription? { get set }
    
    func updateTasks(with tasks: [TodoTask])
    func toggleCompleted(_ task: TodoTask)
    func showError(message: String)
}
