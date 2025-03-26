//
//  TaskDetailRouterDescription.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 26.03.2025.
//

import UIKit

protocol TaskDetailRouterDescription: AnyObject {
    static func start(with task: TodoTask) -> UIViewController
    
    func navigateBack(from vc: TaskDetailViewDescription)
}
