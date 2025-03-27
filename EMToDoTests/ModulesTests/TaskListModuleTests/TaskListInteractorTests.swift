//
//  TaskListInteractorTests.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 27.03.2025.
//

import XCTest
@testable import EMToDo

final class TaskListInteractorTests: XCTestCase {
    var interactor: TaskListInteractor!
    var mockPresenter: TaskListInteractorOutputDescription!
    var dataStorage: DataStoreDescription!
    
    var testFailure = false
    
    override func setUp() {
        super.setUp()
        dataStorage = MockDataStore()
        mockPresenter = MockTaskListPresenterInteratorOutput()
        interactor = TaskListInteractor(dataStorage: dataStorage)
        
        interactor.presenter = mockPresenter
    }
    
    func testFetchTasksSuccess() {
        
        interactor.fetchTasks()
        
        XCTAssertTrue((mockPresenter as! MockTaskListPresenterInteratorOutput).didFetchTasksCalled, "Presenter did not receive tasks")
        XCTAssertEqual((mockPresenter as! MockTaskListPresenterInteratorOutput).fetchedTasks.count, 4, "Presenter received wrong number of tasks")

    }
    
    func testRemoveTask() {

        let taskToRemove = (dataStorage as! MockDataStore).tasks.first!

        interactor.removeTask(taskToRemove)
        
        XCTAssertFalse((dataStorage as! MockDataStore).tasks.contains(where: { $0.id == taskToRemove.id }), "Task was not removed")
        XCTAssertTrue((mockPresenter as! MockTaskListPresenterInteratorOutput).didRemoveTaskCalled, "Presenter did not receive remove task event")
    }
    
    func testToggleTaskCompleted() {
        
        let task = (dataStorage as! MockDataStore).tasks.first!
        let wasCompleted = task.completed
        
        interactor.toggleCompleted(task)
        
        let updatedTask = (dataStorage as! MockDataStore).tasks.first { $0.id == task.id }
        XCTAssertNotEqual(updatedTask?.completed, wasCompleted, "Task completion state was not toggled")
        XCTAssertTrue((mockPresenter as! MockTaskListPresenterInteratorOutput).didToggleCompletedCalled, "Presenter did not receive toggle completed event")
        XCTAssertEqual((mockPresenter as! MockTaskListPresenterInteratorOutput).toggledTask.id, task.id, "Presenter received incorrect task")
    }
    
    func testAddNewTask() {

        interactor.addNewTask()
        
        XCTAssertTrue((mockPresenter as! MockTaskListPresenterInteratorOutput).didAddNewTaskCalled, "Presenter did not receive add new task event")
        XCTAssertEqual((dataStorage as! MockDataStore).tasks.count, 5, "Task was not added to data storage")
    }
    
    func testFetchTasksFailure() {

        let failingDataStore = MockDataStore()
        failingDataStore.failingTests = true
        
        interactor = TaskListInteractor(dataStorage: failingDataStore)
        interactor.presenter = mockPresenter

        interactor.fetchTasks()
        
        XCTAssertTrue((mockPresenter as! MockTaskListPresenterInteratorOutput).didReceiveErrorCalled, "Presenter did not receive error event")
        XCTAssertEqual((mockPresenter as! MockTaskListPresenterInteratorOutput).errorMessage, "Failed to fetch tasks", "Presenter received incorrect error message")
    }
    
    func testRemoveTaskFailure() {

        let failingDataStore = MockDataStore()
        failingDataStore.failingTests = true
        interactor = TaskListInteractor(dataStorage: failingDataStore)
        interactor.presenter = mockPresenter

        let task = (dataStorage as! MockDataStore).tasks.first!
        
        interactor.removeTask(task)
        
        XCTAssertTrue((mockPresenter as! MockTaskListPresenterInteratorOutput).didReceiveErrorCalled, "Presenter did not receive error event")
        XCTAssertEqual((mockPresenter as! MockTaskListPresenterInteratorOutput).errorMessage, "Failed to remove task", "Presenter received incorrect error message")
    }
    
}
