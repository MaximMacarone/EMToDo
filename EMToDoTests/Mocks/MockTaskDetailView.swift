//
//  MockTaskDetailView.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 27.03.2025.
//

import Foundation
@testable import EMToDo

final class MockTaskDetailView: TaskDetailViewDescription {
    var presenter: (any EMToDo.TaskDetailPresenterDescription)?
    
    var didCallSetupTask = false
    var lastSetupTask: TodoTask?
    
    func setupTask(_ task: EMToDo.TodoTask) {
        didCallSetupTask = true
        lastSetupTask = task
    }
}
