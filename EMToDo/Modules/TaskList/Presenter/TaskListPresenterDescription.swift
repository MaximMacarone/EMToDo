//
//  TaskListPresenterDescription.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 25.03.2025.
//

protocol TaskListPresenterDescription: AnyObject {
    var interactor: TaskListInteractroInputDescription? { get set }
    var router: TaskListRouterDescription? { get set }
    var view: TaskListViewDescription? { get set }
    
    func didSelectTask(_ task: TodoTask)
    func addNewTask()
    func deleteTask(_ task: TodoTask)
    func toggleCompleted(_ task: TodoTask)
    func fetchTasks()
}
