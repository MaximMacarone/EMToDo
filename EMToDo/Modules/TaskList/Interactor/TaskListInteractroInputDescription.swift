//
//  TaskListInteractroInputDescription.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 25.03.2025.
//

protocol TaskListInteractroInputDescription: AnyObject {
    var presenter: TaskListInteractorOutputDescription? { get set }
    
    func fetchTasks()
    func removeTask(_ task: TodoTask)
    func addNewTask()
    func toggleCompleted(_ task: TodoTask)
}
