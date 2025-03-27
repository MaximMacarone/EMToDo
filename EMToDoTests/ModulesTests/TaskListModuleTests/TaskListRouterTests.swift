//
//  TaskListRouterTests.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 28.03.2025.
//

import XCTest
@testable import EMToDo

final class TaskListRouterTests: XCTestCase {
    
    func testStart() {
        let viewController = TaskListRouter.start()
        
        XCTAssertTrue(viewController is UINavigationController, "start() should return a UINavigationController")
        
        let navigationController = viewController as! UINavigationController
        XCTAssertTrue(navigationController.viewControllers.first is TaskListViewController,
                      "Root view controller should be TaskListViewController")
        
        let taskListVC = navigationController.viewControllers.first as! TaskListViewController
        XCTAssertNotNil(taskListVC.presenter, "TaskListViewController should have a presenter")
        XCTAssertNotNil(taskListVC.presenter?.interactor, "Presenter should have an interactor")
        XCTAssertNotNil(taskListVC.presenter?.router, "Presenter should have a router")
        XCTAssertNotNil(taskListVC.presenter?.view, "Presenter should have a view")
    }
}
