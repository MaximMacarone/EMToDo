//
//  TaskDetailInteractorInputDescription.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 26.03.2025.
//

protocol TaskDetailInteractorInputDescription: AnyObject {
    var presenter: TaskDetailInteractorOutputDescription? { get set }
    var todoTask: TodoTask? { get set }
    
    func fetchTask() -> TodoTask
    func editTask(title: String, content: String)
}
