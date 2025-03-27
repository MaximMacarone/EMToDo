//
//  MockTaskDetailPresenter.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 27.03.2025.
//

import Foundation
@testable import EMToDo

final class MockTaskDetailPresenterInteractorOutput: TaskDetailInteractorOutputDescription {
    var didCallEditTask: Bool = false
    var didCallFailToEditTask: Bool = false
    
    func didFailToEditTask() {
        didCallFailToEditTask = true
    }
    
    func didEditTask() {
        didCallEditTask = true
    }
}
