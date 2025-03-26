//
//  TaskListRouterDescription.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 25.03.2025.
//

import UIKit

protocol TaskListRouterDescription {
    static func start() -> UIViewController
    
    func presentTaskDetail(on view: TaskListViewDescription, for task: TodoTask)
}
