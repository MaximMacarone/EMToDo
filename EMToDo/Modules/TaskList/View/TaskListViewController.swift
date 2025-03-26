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
    
    let taskCountLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    //MARK: - Private fields
    
    private var tasks: [Task] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.updateTaskCountLabel()
            }
        }
    }
    
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
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

    }
    
    private func setupBottomToolbar() {
        navigationController?.setToolbarHidden(false, animated: true)
        
        let newTaskButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: nil)
        let taskCountItem = UIBarButtonItem(title: nil, image: nil, target: self, action: nil)
        
        taskCountLabel.text = tasks.count.tasksCountString()
        taskCountItem.customView = self.taskCountLabel
        
        toolbarItems = [
            .flexibleSpace(),
            taskCountItem,
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
    
    //MARK: - Methods
    
    private func updateTaskCountLabel() {
        taskCountLabel.text = tasks.count.tasksCountString()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(TaskDetailViewController(), animated: true)
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {
            fatalError()
        }
        
        cell.delegate = self
        cell.configure(with: tasks[indexPath.row])
        
        return cell
    }
}

extension TaskListViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}

extension TaskListViewController: TaskTableViewCellDelegate {
    func didTapCheckbox(for cell: TaskTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        var task = tasks[indexPath.row]
        print("didTap")
        task.completed.toggle()
        tasks[indexPath.row] = task
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
