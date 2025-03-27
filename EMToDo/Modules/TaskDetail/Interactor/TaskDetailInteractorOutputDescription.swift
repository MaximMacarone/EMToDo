//
//  TaskDetailInteractorOutputDescription.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 26.03.2025.
//

protocol TaskDetailInteractorOutputDescription: AnyObject {
    func didEditTask()
    func didFailToEditTask()
}
