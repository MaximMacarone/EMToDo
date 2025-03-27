//
//  MockTaskDetailRouter.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 27.03.2025.
//

import UIKit
@testable import EMToDo

final class MockTaskDetailRouter: TaskDetailRouterDescription {
    static func start(with task: EMToDo.TodoTask) -> UIViewController {
        return UIViewController()
    }
}
