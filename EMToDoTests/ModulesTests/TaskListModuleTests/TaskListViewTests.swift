//
//  TaskListViewTests.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 28.03.2025.
//

import XCTest
@testable import EMToDo

final class TaskListViewTests: XCTestCase {
    var viewController: TaskListViewController!
    var mockPresenter: TaskListPresenterDescription!
    
    override func setUp() {
        super.setUp()
        viewController = TaskListViewController()
        mockPresenter = MockTaskListPresenter()
        viewController.presenter = mockPresenter
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        mockPresenter = nil
        super.tearDown()
    }
    
    func testViewDidAppear() {
        viewController.viewDidAppear(false)
        
        XCTAssertTrue((mockPresenter as! MockTaskListPresenter).fetchTasksCalled, "fetchTasks() was not called")
    }
    
    func testUpdateTasks() {
        let tasks = [
            TodoTask(id: 1, title: "Task 1", description: "Content 1", completed: false),
            TodoTask(id: 2, title: "Task 2", description: "Content 2", completed: false)
        ]
        
        let expectation = XCTestExpectation(description: "TableView updates")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            XCTAssertEqual(self?.viewController.getTableView.numberOfRows(inSection: 0), 2, "Table was not updated with tasks")
            expectation.fulfill()
        }

        viewController.updateTasks(with: tasks)

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testToggleCompleted() {
        let task = TodoTask(id: 1, title: "Task", description: "Content", completed: false)
        viewController.updateTasks(with: [task])
        let toggledTask = TodoTask(id: 1, title: "Task", description: "Content", completed: true)
        
        viewController.toggleCompleted(toggledTask)
        
        XCTAssertEqual(viewController.getTasks.first?.completed, true, "Task completion did not toggle")
    }

}
