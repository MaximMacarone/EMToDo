//
//  LocalTodoTask+CoreDataProperties.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 26.03.2025.
//
//

import Foundation
import CoreData


extension LocalTodoTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalTodoTask> {
        return NSFetchRequest<LocalTodoTask>(entityName: "LocalTodoTask")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var content: String
    @NSManaged public var createdAt: Date
    @NSManaged public var title: String
    @NSManaged public var id: Int64

}

extension LocalTodoTask : Identifiable {

}

extension LocalTodoTask {
    func toTodoTask() -> TodoTask {
        return TodoTask(
            id: Int(self.id),
            title: self.title,
            description: self.content,
            completed: self.completed
        )
    }
}
