//
//  TaskListRouter.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 26.03.2025.
//

import UIKit

final class TaskListRouter: TaskListRouterDescription {
    static func start() -> UIViewController {
        let taskListVC = TaskListViewController()
        let taskListRouter = TaskListRouter()
        var taskListPresenter: TaskListPresenterDescription & TaskListInteractorOutputDescription = TaskListPresenter()
        var taskListInteractor: TaskListInteractroInputDescription = TaskListInteractor()
        
        taskListVC.presenter = taskListPresenter
        
        taskListPresenter.interactor = taskListInteractor
        taskListPresenter.router = taskListRouter
        taskListPresenter.view = taskListVC
        
        taskListInteractor.presenter = taskListPresenter
        
        return UINavigationController(rootViewController: taskListVC)
    }
    
    func presentTaskDetail(on view: any TaskListViewDescription, for task: TodoTask) {
        print("presenting detail view for task: \(task)")
    }
}
