//
//  TaskListPresenterTests.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 27.03.2025.
//

import XCTest
@testable import EMToDo

final class TaskListPresenterTests: XCTestCase {
    var presenter: (TaskListPresenterDescription & TaskListInteractorOutputDescription)!
    var mockView: TaskListViewDescription!
    var mockInteractor: TaskListInteractorInputDescription!
    var mockRouter: TaskListRouterDescription!
    
    override func setUp() {
        super.setUp()
        mockView = MockTaskListView()
        mockInteractor = MockTaskListInteractor()
        mockRouter = MockTaskListRouter()
        
        presenter = TaskListPresenter()
        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
        
        mockInteractor.presenter = presenter
        mockView.presenter = presenter
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func testAddNewTask() {
        presenter.addNewTask()
        
        XCTAssertTrue((mockInteractor as! MockTaskListInteractor).didCallAddNewTask, "Interactor did not call addNewTask(")
    }
    
    func testDeleteTask() {
        let task = TodoTask(id: 1, title: "Test", description: "", completed: false)
        
        presenter.deleteTask(task)
        
        XCTAssertTrue((mockInteractor as! MockTaskListInteractor).didCallRemoveTask, "Interactor did not call removeTask()")
    }
    
    func testToggleCompleted() {
        let task = TodoTask(id: 1, title: "Test", description: "", completed: false)
        
        presenter.toggleCompleted(task)
        
        XCTAssertTrue((mockInteractor as! MockTaskListInteractor).didCallToggleCompleted, "Interactor did not call toggleCompleted()")
    }
    
    func testFetchTasks() {
        presenter.fetchTasks()
        
        XCTAssertTrue((mockInteractor as! MockTaskListInteractor).didCallFetchTasks, "Interactor did not call fetchTasks()")
    }
    
    func testDidSelectTask() {
        let task = TodoTask(id: 1, title: "Test", description: "", completed: false)
        
        presenter.didSelectTask(task)
        
        XCTAssertTrue((mockRouter as! MockTaskListRouter).didCallPresentTaskDetail, "Router did not call presentTaskDetail()")
        XCTAssertEqual((mockRouter as! MockTaskListRouter).presentedTask?.id, task.id, "Wrong task got presented")
    }
    
    func testDidFetchTasks() {
        let tasks = [
            TodoTask(id: 1, title: "Task 1", description: "", completed: false),
            TodoTask(id: 2, title: "Task 2", description: "", completed: true)
        ]
        
        presenter.didFetchTasks(tasks)
        
        XCTAssertTrue((mockView as! MockTaskListView).didCallUpdateTasks, "View did not call updateTasks()")
        XCTAssertEqual((mockView as! MockTaskListView).tasks.count, 2, "View did not get 2 tasks")
        XCTAssertEqual(tasks, (mockView as! MockTaskListView).tasks, "View did get wrong tasks")
    }
    
    func testDidReceiveError() {
        let errorMessage = "Test error"
        
        presenter.didReceiveError(errorMessage)
        
        XCTAssertTrue((mockView as! MockTaskListView).didCallShowError, "View did not call showError()")
        XCTAssertEqual((mockView as! MockTaskListView).errMsg, errorMessage, "View did get wrong error message")
    }
    
    func testDidToggleCompleted() {
        let task = TodoTask(id: 1, title: "Task 1", description: "", completed: false)
        
        presenter.didToggleCompleted(task)
        
        XCTAssertTrue((mockView as! MockTaskListView).didCallToggleCompleted, "View did not call toggleCompleted()")
        XCTAssertEqual((mockView as! MockTaskListView).toggledTaskComplete!, false, "Task.completed did not update correctly")
    }
    
}
