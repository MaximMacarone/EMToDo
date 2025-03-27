//
//  MockTaskDetailPresenter.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 28.03.2025.
//

import Foundation
@testable import EMToDo

final class MockTaskDetailPresenter: TaskDetailPresenterDescription {
    var interactor: (any EMToDo.TaskDetailInteractorInputDescription)?
    
    var router: (any EMToDo.TaskDetailRouterDescription)?
    
    var view: (any EMToDo.TaskDetailViewDescription)?
    
    var setupCall: Bool = false
    var updateTaskCall: Bool = false
    
    var task = TodoTask(id: 1, title: "Test Task", description: "Test description", completed: false)
    
    func setup() {
        setupCall = true
        view?.setupTask(task)
    }
    
    func updateTask(title: String, content: String) {
        updateTaskCall = true
        
    }
    
    
}
