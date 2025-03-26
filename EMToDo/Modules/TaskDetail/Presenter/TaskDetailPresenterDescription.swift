//
//  TaskDetailPresenterDescription.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 26.03.2025.
//

protocol TaskDetailPresenterDescription: AnyObject {
    var interactor: TaskDetailInteractorInputDescription? { get set }
    var router: TaskDetailRouterDescription? { get set }
    var view: TaskDetailViewDescription? { get set }
    
    func setup()
    func updateTask(title: String, content: String)
}
