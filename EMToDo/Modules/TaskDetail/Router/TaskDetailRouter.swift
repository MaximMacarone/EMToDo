//
//  TaskDetailRouter.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 26.03.2025.
//

import UIKit

final class TaskDetailRouter: TaskDetailRouterDescription {
    static func start(with task: TodoTask) -> UIViewController {
        let detailVC = TaskDetailViewController()
        
        let presenter = TaskDetailPresenter()
        let interactor = TaskDetailInteractor()
        let router = TaskDetailRouter()
        
        detailVC.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = detailVC
        
        interactor.presenter = presenter
        interactor.task = task
        
        return detailVC
        
    }
}
