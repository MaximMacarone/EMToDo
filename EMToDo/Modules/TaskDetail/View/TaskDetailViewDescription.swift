//
//  TaskDetailViewDescription.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 26.03.2025.
//

protocol TaskDetailViewDescription: AnyObject {
    var presenter: TaskDetailPresenterDescription? { get set }
    
    func setupTask(_ task: TodoTask)
}
