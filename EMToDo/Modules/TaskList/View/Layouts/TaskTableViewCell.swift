//
//  TaskTableViewCell.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 25.03.2025.
//

import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
    func didTapCheckbox(for cell: TaskTableViewCell)
}

protocol TaskCellContextMenuDelegate: AnyObject {
    func didSelectEdit(for cell: TaskTableViewCell)
    func didSelectShare(for cell: TaskTableViewCell)
    func didSelectDelete(for cell: TaskTableViewCell)
}

class TaskTableViewCell: UITableViewCell {
    
    static let identifier: String = "taskCell"
    
    //MARK: - Properties
    
    weak var delegate: TaskTableViewCellDelegate?
    weak var contextMenuDelegate: TaskCellContextMenuDelegate?
    
    //MARK: - Subviews
    
    let checkBoxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .secondaryLabel
        button.imageView?.contentMode = .scaleAspectFit
        
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = .zero
        configuration.contentInsets = .zero
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(weight: .thin)
        
        button.configuration = configuration
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        return label
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupCheckboxButtonTarget()
        
        let interaction = UIContextMenuInteraction(delegate: self)
        addInteraction(interaction)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Setup
    
    private func setupUI() {
        contentView.addSubview(checkBoxButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        
        checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkBoxButton.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            checkBoxButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            checkBoxButton.widthAnchor.constraint(equalToConstant: 24),
            checkBoxButton.heightAnchor.constraint(equalToConstant: 48),
            
            titleLabel.leadingAnchor.constraint(equalTo: checkBoxButton.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    private func setupCheckboxButtonTarget() {
        checkBoxButton.addTarget(self, action: #selector(didTapCheckbox), for: .touchUpInside)
    }
    
    //MARK: - Methods
    
    func configure(with task: TodoTask) {
        descriptionLabel.text = task.description
        dateLabel.text = task.createdAt.formatted()
        
        titleLabel.attributedText = nil
        
        configureCompletionState(with: task)
    }
    
    private func makePreview() -> UIViewController {
        let previewVC = UIViewController()
            
        let previewTitleLabel = UILabel()
        previewTitleLabel.font = .preferredFont(forTextStyle: .headline)
        previewTitleLabel.textColor = titleLabel.textColor
        previewTitleLabel.attributedText = titleLabel.attributedText
        
        let previewDescriptionLabel = UILabel()
        previewDescriptionLabel.font = .preferredFont(forTextStyle: .caption1)
        previewDescriptionLabel.textColor = descriptionLabel.textColor
        previewDescriptionLabel.numberOfLines = 2
        previewDescriptionLabel.text = descriptionLabel.text

        let previewDateLabel = UILabel()
        previewDateLabel.font = .preferredFont(forTextStyle: .caption1)
        previewDateLabel.textColor = dateLabel.textColor
        previewDateLabel.text = dateLabel.text
        
        previewVC.view.addSubview(previewTitleLabel)
        previewVC.view.addSubview(previewDescriptionLabel)
        previewVC.view.addSubview(previewDateLabel)
        
        previewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        previewDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        previewDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            previewTitleLabel.leadingAnchor.constraint(equalTo: previewVC.view.leadingAnchor, constant: 16),
            previewTitleLabel.topAnchor.constraint(equalTo: previewVC.view.topAnchor, constant: 12),
            previewTitleLabel.trailingAnchor.constraint(equalTo: previewVC.view.trailingAnchor, constant: -16),
            
            previewDescriptionLabel.leadingAnchor.constraint(equalTo: previewTitleLabel.leadingAnchor),
            previewDescriptionLabel.topAnchor.constraint(equalTo: previewTitleLabel.bottomAnchor, constant: 6),
            previewDescriptionLabel.trailingAnchor.constraint(equalTo: previewTitleLabel.trailingAnchor),
            
            previewDateLabel.leadingAnchor.constraint(equalTo: previewTitleLabel.leadingAnchor),
            previewDateLabel.trailingAnchor.constraint(equalTo: previewTitleLabel.trailingAnchor),
            previewDateLabel.topAnchor.constraint(equalTo: previewDescriptionLabel.bottomAnchor, constant: 6),
            previewDateLabel.bottomAnchor.constraint(equalTo: previewVC.view.bottomAnchor, constant: -12)
        ])
    
        previewVC.preferredContentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
        
        return previewVC
    }
    
    private func configureCompletionState(with task: TodoTask) {
        if task.completed {
            checkBoxButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            checkBoxButton.tintColor = .accent
            
            titleLabel.textColor = .secondaryLabel
            descriptionLabel.textColor = .secondaryLabel
            
            titleLabel.attributedText = NSAttributedString(
                string: task.title,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
        } else {
            checkBoxButton.setImage(UIImage(systemName: "circle"), for: .normal)
            checkBoxButton.tintColor = .secondaryLabel
            
            titleLabel.textColor = .label
            descriptionLabel.textColor = .label
            
            titleLabel.attributedText = NSAttributedString(
                string: task.title
            )

        }
    }
    
    @objc private func didTapCheckbox() {
        delegate?.didTapCheckbox(for: self)
    }
    
}

extension TaskTableViewCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: makePreview) { [weak self] _ -> UIMenu? in
            
            // Menu actions
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "square.and.pencil"), identifier: nil, discoverabilityTitle: nil) { [weak self] _ in
                self?.contextMenuDelegate?.didSelectEdit(for: self!)
            }
            let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up"), identifier: nil, discoverabilityTitle: nil) { [weak self] _ in
                self?.contextMenuDelegate?.didSelectShare(for: self!)
            }
            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil, attributes: .destructive) { [weak self] _ in
                self?.contextMenuDelegate?.didSelectDelete(for: self!)
            }
            
            return UIMenu(children: [editAction, shareAction, deleteAction])
        }
        
    }
}
