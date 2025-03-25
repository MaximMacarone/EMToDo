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
    
    private var tasks: [Task] = []
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupNavBar()
        setupTableView()
        setupBottomToolbar()
        setupSearchController()
        
        fetchTasks()
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
        
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupBottomToolbar() {
        navigationController?.setToolbarHidden(false, animated: true)
        
        let newTaskButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: nil)
        let taskCountLabel = UIBarButtonItem(title: nil, image: nil, target: self, action: nil)
        
        let label = UILabel()
        label.text = "\(tasks.count) задач"
        label.font = .preferredFont(forTextStyle: .footnote)
        taskCountLabel.customView = label
        
        toolbarItems = [
            .flexibleSpace(),
            taskCountLabel,
            .flexibleSpace(),
            newTaskButton
        ]
    }
    
    private func setupSearchController() {
        let searchController = UISearchController()
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .no
        
        navigationItem.searchController = searchController
    }
    
    func fetchTasks() {
        APIService.shared.fetchTasks { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let tasks):
                self.tasks = tasks
                print(tasks)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension TaskListViewController: UITableViewDelegate {
    
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {
            fatalError()
        }
        
        cell.configure(with: tasks[indexPath.row])
        
        return cell
    }
}

extension TaskListViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}
