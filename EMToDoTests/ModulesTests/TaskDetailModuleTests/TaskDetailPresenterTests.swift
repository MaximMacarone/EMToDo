//
//  TaskDetailPresenterTests.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 27.03.2025.
//

import XCTest
@testable import EMToDo

final class TaskDetailPresenterTests: XCTestCase {
    var presenter: TaskDetailPresenter!
    var mockView: TaskDetailViewDescription!
    var mockInteractor: TaskDetailInteractorInputDescription!
    var mockRouter: TaskDetailRouterDescription!
    
    override func setUp() {
        super.setUp()
        mockView = MockTaskDetailView()
        mockInteractor = MockTaskDetailInteractor()
        mockRouter = MockTaskDetailRouter()
        
        presenter = TaskDetailPresenter()
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
    
    func testSetup() {
        let task = TodoTask(id: 1, title: "Test Task", description: "Test Content", completed: false)
        mockInteractor.todoTask = task
        
        presenter.setup()
        
        XCTAssertTrue((mockView as! MockTaskDetailView).didCallSetupTask, "View did not call setupTask()")
        XCTAssertEqual((mockView as! MockTaskDetailView).lastSetupTask?.id, task.id, "Task did not match")
    }
    
    func testUpdateTask() {
        presenter.updateTask(title: "Updated Title", content: "Updated Content")
        
        XCTAssertTrue((mockInteractor as! MockTaskDetailInteractor).didCallEditTask, "Interactor did not call editTask()")
        XCTAssertEqual((mockInteractor as! MockTaskDetailInteractor).lastEditTitle, "Updated Title", "Title did not match")
        XCTAssertEqual((mockInteractor as! MockTaskDetailInteractor).lastEditContent, "Updated Content", "Description did not match")
    }
    
}
