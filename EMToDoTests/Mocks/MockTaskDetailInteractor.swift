//
//  MockTaskDetailInteractor.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 27.03.2025.
//

import Foundation
@testable import EMToDo

final class MockTaskDetailInteractor: TaskDetailInteractorInputDescription {
    var presenter: (any EMToDo.TaskDetailInteractorOutputDescription)?
    
    var todoTask: EMToDo.TodoTask?
    var didCallFetchTask = false
    var didCallEditTask = false
    var lastEditTitle: String?
    var lastEditContent: String?
    
    func fetchTask() -> EMToDo.TodoTask {
        didCallFetchTask = true
        return todoTask ?? EMToDo.TodoTask(id: 0, title: "Default", description: "", completed: false)
    }
    
    func editTask(title: String, content: String) {
        didCallEditTask = true
        lastEditTitle = title
        lastEditContent = content
    }
    
}
