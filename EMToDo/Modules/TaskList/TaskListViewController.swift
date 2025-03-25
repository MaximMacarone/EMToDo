//
//  TaskListViewController.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 25.03.2025.
//

import UIKit

class TaskListViewController: UIViewController, TaskListViewDescription {
    
    //MARK: - Subviews
    
    let tableView = UITableView()
    
    //MARK: - Private fields
    
    private var tasks: [Task] = [
        Task(title: "First task", description: "First description"),
        Task(title: "Second task", description: "Second description"),
        Task(title: "Third task", description: "Third description"),
        Task(title: "Fourth task", description: "Fourth description"),
        Task(title: "Fifth task", description: "Fifth description"),
        Task(title: "First task", description: "First description"),
        Task(title: "Second task", description: "Second description"),
        Task(title: "Third task", description: "Third description"),
        Task(title: "Fourth task", description: "Fourth description"),
        Task(title: "Fifth task", description: "Fifth description"),
        Task(title: "First task", description: "First description"),
        Task(title: "Second task", description: "Second description"),
        Task(title: "Third task", description: "Third description"),
        Task(title: "Fourth task", description: "Fourth description"),
        Task(title: "Fifth task", description: "Fifth description"),
        Task(title: "First task", description: "First description"),
        Task(title: "Second task", description: "Second description"),
        Task(title: "Third task", description: "Third description"),
        Task(title: "Fourth task", description: "Fourth description"),
        Task(title: "Fifth task", description: "Fifth description"),
        Task(title: "First task", description: "First description"),
        Task(title: "Second task", description: "Second description"),
        Task(title: "Third task", description: "Third description"),
        Task(title: "Fourth task", description: "Fourth description"),
        Task(title: "Fifth task", description: "Fifth description"),
    ]
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupNavBar()
        setupTableView()
        setupBottomToolbar()
    }
    
    //MARK: - UI Setup
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
    }
    
    private func setupNavBar() {
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "taskCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupBottomToolbar() {
        
        // Toolbar items
        let newTaskButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: nil)
        
        let taskCountLabel = UIBarButtonItem(title: nil, image: nil, target: self, action: nil)
        let label = UILabel()
        label.text = "\(tasks.count) задач"
        label.textColor = .label
        taskCountLabel.customView = label
        
        navigationController?.setToolbarHidden(false, animated: true)
        navigationController?.toolbar.isOpaque = true
        toolbarItems = [.flexibleSpace(), taskCountLabel, .flexibleSpace(), newTaskButton]
    }

}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ -> UIMenu? in
            
            // Menu actions
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "square.and.pencil"), identifier: nil, discoverabilityTitle: nil) { _ in
                
            }
            let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up"), identifier: nil, discoverabilityTitle: nil) { _ in }
            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil, attributes: .destructive) { action in
                
            }
            
            return UIMenu(children: [editAction, shareAction, deleteAction])
        }
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        
        // Cell configuration
        var config = cell.defaultContentConfiguration()
        config.text = "Task"
        config.secondaryText = "Description"
        config.textProperties.color = .label
        
        cell.contentConfiguration = config
        
        return cell
    }
}
