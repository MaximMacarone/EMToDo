//
//  TaskDetailInteractor.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 26.03.2025.
//

import CoreData

final class TaskDetailInteractor: TaskDetailInteractorInputDescription {
    
    //MARK: - VIPER
    
    var presenter: (any TaskDetailInteractorOutputDescription)?
    
    //MARK: - Properties
    
    var task: TodoTask?
    
    var todoTask: TodoTask?
    
    func fetchTask() -> TodoTask {
        guard let task else {
            fatalError("Failed to fetch task")
        }
        return task
    }
    
    func editTask(title: String, content: String) {
        
        CoreDataStack.shared.performBackgroundTask { [weak self] context in
            guard let self else { return }
            
            let fetchRequest: NSFetchRequest<LocalTodoTask> = LocalTodoTask.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(self.task?.id ?? 0))
            
            do {

                let results = try context.fetch(fetchRequest)
                if let localTask = results.first {

                    localTask.title = title
                    localTask.content = content

                    try context.save()
                } else {

                }
            } catch {
                
            }
        }
    }
}
