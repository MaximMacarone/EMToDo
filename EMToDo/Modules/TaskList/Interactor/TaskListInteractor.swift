//
//  TaskListInteractor.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 26.03.2025.
//

final class TaskListInteractor: TaskListInteractroInputDescription {
    
    //MARK: - VIPER
    
    var presenter: (any TaskListInteractorOutputDescription)?
    
    //MARK: - Properties
    
    var tasks = [TodoTask]()
    
    //MARK: - Methods
    
    func fetchTasks() {
        APIService.shared.fetchTasks { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let tasks):
                self.tasks = tasks
                self.presenter?.didFetchTasks(self.tasks)
            case .failure(let error):
                self.presenter?.didReceiveError(error.localizedDescription)
            }
        }
    }
    
    func fetchTasksLocal() {
        presenter?.didFetchTasks(tasks)
    }
    
    func removeTask(_ task: TodoTask) {
        guard let index = tasks.firstIndex(where: {$0.id == task.id}) else { return }
        tasks.remove(at: index)
        presenter?.didRemoveTask()
    }
    
    func toggleCompleted(_ task: TodoTask) {
        guard let index = tasks.firstIndex(where: {$0.id == task.id}) else { return }
        
        tasks[index].completed.toggle()
        presenter?.didToggleCompleted(tasks[index])
    }
    
}
