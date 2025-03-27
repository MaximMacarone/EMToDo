//
//  MockTaskListRouter.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 27.03.2025.
//

import UIKit
@testable import EMToDo

final class MockTaskListRouter: TaskListRouterDescription {
    
    var didCallPresentTaskDetail: Bool = false
    var presentedTask: EMToDo.TodoTask?
    
    static func start() -> UIViewController {
        return UIViewController()
    }
    
    func presentTaskDetail(on view: any EMToDo.TaskListViewDescription, for task: EMToDo.TodoTask) {
        didCallPresentTaskDetail = true
        presentedTask = task
    }
    
}
