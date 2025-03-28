//
//  TaskListViewController.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 25.03.2025.
//

import UIKit

class TaskListViewController: UIViewController, TaskListViewDescription {
    
    //MARK: - VIPER
    
    var presenter: (any TaskListPresenterDescription)?
    
    //MARK: - Subviews
    
    private let tableView = UITableView()
    
    private let taskCountLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - Private fields
    
    private enum Section {
        case main
    }
    
    private var tasks: [TodoTask] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.updateTaskCountLabel()
            }
        }
    }
    
    private var dataSource: UITableViewDiffableDataSource<Section, TodoTask>!
    private var filteredTasks: [TodoTask] = []
    private var isSearchActive: Bool {
        return !(searchController.searchBar.text ?? "").isEmpty
    }
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupNavBar()
        setupTableView()
        setupBottomToolbar()
        setupSearchController()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTasks()
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
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {
                fatalError()
            }
            
            cell.delegate = self
            cell.contextMenuDelegate = self
            cell.configure(with: item)
            
            return cell
        })
        dataSource.defaultRowAnimation = .none
        
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
        
        let newTaskButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapNewTask))
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
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .no
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    //MARK: - Methods
    
    private func updateTaskCountLabel() {
        taskCountLabel.text = tasks.count.tasksCountString()
    }
    
    @objc private func didTapNewTask() {
        presenter?.addNewTask()
    }
    
    func updateTasks(with tasks: [TodoTask]) {
        self.tasks = tasks
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if self.isSearchActive {
                self.updateSearchResults(for: searchController)
            } else {
                self.updateTableViewItems(with: tasks)
            }
        }
    }
    
    private func updateTableViewItems(with tasks: [TodoTask]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TodoTask>()
        snapshot.appendSections([.main])
        snapshot.appendItems(tasks, toSection: .main)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error occured", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    func toggleCompleted(_ task: TodoTask) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id}) else { return }
        tasks[index] = task
        
        updateTasks(with: tasks)
    }
    
    private func loadTasks() {
        presenter?.fetchTasks()
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task: TodoTask
        if isSearchActive {
            task = filteredTasks[indexPath.row]
        } else {
            task = tasks[indexPath.row]
        }
        
        presenter?.didSelectTask(task)
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filteredTasks.count : tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.contextMenuDelegate = self
        cell.configure(with: tasks[indexPath.row])
        
        return cell
    }
}

extension TaskListViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.lowercased() ?? ""
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            
            let filteredTasks: [TodoTask]
            
            if searchText.isEmpty {
                filteredTasks = tasks
            } else {
                filteredTasks = tasks.filter { task in
                    task.title.lowercased().contains(searchText) ||
                    task.description.lowercased().contains(searchText)
                }
            }
            
            DispatchQueue.main.async {
                self.filteredTasks = filteredTasks
                self.updateTableViewItems(with: filteredTasks)
            }
        }
    }
}

extension TaskListViewController: TaskTableViewCellDelegate {
    func didTapCheckbox(for cell: TaskTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let task: TodoTask
        if isSearchActive {
            task = filteredTasks[indexPath.row]
        } else {
            task = tasks[indexPath.row]
        }
        
        presenter?.toggleCompleted(task)

    }
}

extension TaskListViewController: TaskCellContextMenuDelegate {
    func didSelectEdit(for cell: TaskTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let task: TodoTask
        if isSearchActive {
            task = filteredTasks[indexPath.row]
        } else {
            task = tasks[indexPath.row]
        }
        
        presenter?.didSelectTask(task)
    }
    
    func didSelectShare(for cell: TaskTableViewCell) {
        // Share logic
    }
    
    func didSelectDelete(for cell: TaskTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let task: TodoTask
        if isSearchActive {
            task = filteredTasks[indexPath.row]
        } else {
            task = tasks[indexPath.row]
        }
        
        let alert = UIAlertController(title: "Удалить задачу?", message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.presenter?.deleteTask(task)
        }
        alert.addAction(deleteAction)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }
    
}

//For tests
extension TaskListViewController {
    var getTasks: [TodoTask] {
        return tasks
    }
    
    var getTableView: UITableView {
        return tableView
    }
}
