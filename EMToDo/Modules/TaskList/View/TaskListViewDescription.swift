//
//  TaskListViewDescription.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 25.03.2025.
//

protocol TaskListViewDescription: AnyObject {
    var presenter: TaskListPresenterDescription? { get set }
    
    func updateTableView(with tasks: [TodoTask])
    func showError(message: String)
}
