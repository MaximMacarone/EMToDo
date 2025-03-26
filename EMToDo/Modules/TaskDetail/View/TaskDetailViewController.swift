//
//  TaskDetailViewController.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 26.03.2025.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    //MARK: - Subviews
    
    let titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 34, weight: .bold)
        textView.textColor = .label
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.text = "Buy milk"
        return textView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        
        label.text = "02/10/24"
        
        return label
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.textColor = .label
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.text = "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике."
        return textView
    }()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
    }
    
    private func setupUI() {
        
        view.addSubview(titleTextView)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)
        
        navigationItem.largeTitleDisplayMode = .never
        
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleTextView.trailingAnchor),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: titleTextView.trailingAnchor),
        ])
    }

}
