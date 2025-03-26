//
//  TaskDetailPresenter.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 26.03.2025.
//

final class TaskDetailPresenter: TaskDetailPresenterDescription {
    var interactor: (any TaskDetailInteractorInputDescription)?
    
    var router: (any TaskDetailRouterDescription)?
    
    var view: (any TaskDetailViewDescription)?
    
    func setup() {
        guard let task = interactor?.fetchTask() else {
            return
        }
        view?.setupTask(task)
    }
    
    func updateTask(title: String, content: String) {
        interactor?.editTask(title: title, content: content)
    }
}

extension TaskDetailPresenter: TaskDetailInteractorOutputDescription {
    func didEditTask(with id: Int) {
        
    }
    
}
