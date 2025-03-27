//
//  TaskDetailRouterTests.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 28.03.2025.
//

import XCTest
@testable import EMToDo

final class TaskDetailRouterTests: XCTestCase {
    
    func testStart() {
        let task = TodoTask(id: 1, title: "Test Task", description: "Content", completed: false)

        let viewController = TaskDetailRouter.start(with: task)

        XCTAssertTrue(viewController is TaskDetailViewController,
                      "start(with:) should return a TaskDetailViewController")
        
        let detailVC = viewController as! TaskDetailViewController
        XCTAssertNotNil(detailVC.presenter, "TaskDetailViewController should have a presenter")
        
        let presenter = detailVC.presenter as? TaskDetailPresenter
        XCTAssertNotNil(presenter?.interactor, "Presenter should have an interactor")
        XCTAssertNotNil(presenter?.router, "Presenter should have a router")
        XCTAssertNotNil(presenter?.view, "Presenter should have a view")
        
        let interactor = presenter?.interactor as? TaskDetailInteractor
        XCTAssertNotNil(interactor?.presenter, "Interactor should have a presenter")
        XCTAssertEqual(interactor?.task?.id, task.id, "Interactor should store the passed task")
    }
}
