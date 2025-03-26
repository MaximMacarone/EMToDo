//
//  TaskListInteractroInputDescription.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 25.03.2025.
//

protocol TaskListInteractroInputDescription {
    var presenter: TaskListInteractorOutputDescription? { get set }
    
    func fetchTasks()
    func fetchTasksLocal()
    func removeTask(_ task: TodoTask)
    func toggleCompleted(_ task: TodoTask)
}
