//
//  TaskDetailInteractorTests.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 27.03.2025.
//

import XCTest
@testable import EMToDo

final class TaskDetailInteractorTests: XCTestCase {
    var interactor: TaskDetailInteractor!
    var mockPresenter: TaskDetailInteractorOutputDescription!
    var mockDataStore: DataStoreDescription!
    var mockTask: TodoTask!
    
    override func setUp() {
        super.setUp()
        
        mockDataStore = MockDataStore()
        mockPresenter = MockTaskDetailPresenterInteractorOutput()
        
        interactor = TaskDetailInteractor(dataStore: mockDataStore)
        interactor.presenter = mockPresenter
        interactor.task = (mockDataStore as! MockDataStore).tasks.first!
    }
    
    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockDataStore = nil
        mockTask = nil
        
        super.tearDown()
    }
    
    func testFetchTask() {
        let task = interactor.fetchTask()
        
        XCTAssertEqual(task.id, 1)
        XCTAssertEqual(task.title, "Mock")
        XCTAssertEqual(task.description, "Mock")
    }
    
    func testEditTask() {
        let newTitle = "Updated Task"
        let newContent = "Updated Description"
        
        interactor.editTask(title: newTitle, content: newContent)
        
        XCTAssertTrue((mockPresenter as! MockTaskDetailPresenterInteractorOutput).didCallEditTask)
        
    }
    
    func testFailToEditTask() {
        (mockDataStore as! MockDataStore).failingTests = true
        
        let newTitle = "Updated Task"
        let newContent = "Updated Description"
        
        interactor.editTask(title: newTitle, content: newContent)
        
        XCTAssertTrue((mockPresenter as! MockTaskDetailPresenterInteractorOutput).didCallFailToEditTask)
    }
}


