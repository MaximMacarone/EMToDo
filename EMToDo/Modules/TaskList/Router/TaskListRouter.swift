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
        let taskListPresenter: TaskListPresenterDescription & TaskListInteractorOutputDescription = TaskListPresenter()
        let taskListInteractor: TaskListInteractorInputDescription = TaskListInteractor(dataStorage: TaskDataStore.shared)
        
        taskListPresenter.interactor = taskListInteractor
        taskListPresenter.router = taskListRouter
        taskListPresenter.view = taskListVC
        
        taskListVC.presenter = taskListPresenter
        
        taskListInteractor.presenter = taskListPresenter
        
        return UINavigationController(rootViewController: taskListVC)
    }
    
    func presentTaskDetail(on view: any TaskListViewDescription, for task: TodoTask) {
        
        let detailVC = TaskDetailRouter.start(with: task)
        
        guard let viewVC = view as? UIViewController else {
            fatalError("Failed to navigate to task detail view")
        }
        
        viewVC.navigationController?.pushViewController(detailVC, animated: true)
        
    }
}
