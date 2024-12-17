//
//  FoodRecipeFormViewController.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 16/12/24.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

class FoodRecipeFormViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let nameContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Recipe Name"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Recipe Name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let selectIngredientsButton: UIButton = {
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Ingredients"
        configuration.image = UIImage(systemName: "plus")
        configuration.imagePadding = 8
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        
        button.configuration = configuration
        return button
    }()
    
    private let ingredientsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - RxSwift
    private let disposeBag = DisposeBag()
    private let selectedIngredientsRelay = BehaviorRelay<[RecipeIngredient]>(value: [])
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Add Recipe"
        
        setupScrollView()
        setupStackView()
        setupTableView()
        bindTableView()
    }
    
    // MARK: - Setup Methods
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        selectIngredientsButton.addTarget(self, action: #selector(onSelectIngredientTap), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private func setupStackView() {
        setupNameContainerView()
        stackView.addArrangedSubview(nameContainerView)
        stackView.addArrangedSubview(selectIngredientsButton)
        stackView.addArrangedSubview(ingredientsTableView)
        
        ingredientsTableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func setupNameContainerView() {
        nameContainerView.addSubview(subtitleLabel)
        nameContainerView.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: nameContainerView.topAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: nameContainerView.leadingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: nameContainerView.trailingAnchor, constant: -8),
            
            nameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: nameContainerView.leadingAnchor, constant: 8),
            nameTextField.trailingAnchor.constraint(equalTo: nameContainerView.trailingAnchor, constant: -8),
            nameTextField.bottomAnchor.constraint(equalTo: nameContainerView.bottomAnchor, constant: -8),
            nameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupTableView() {
        ingredientsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "IngredientCell")
    }
    
    private func bindTableView() {
        // Bind dos ingredientes selecionados à TableView
        selectedIngredientsRelay
            .bind(to: ingredientsTableView.rx.items(cellIdentifier: "IngredientCell")) { _, ingredient, cell in
                cell.textLabel?.text = ingredient.name ?? "Unnamed Ingredient"
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    
    @objc private func onSelectIngredientTap() {
        let viewController = SelectIngredientViewController(selected: selectedIngredientsRelay.value) { [weak self] ingredients in
            guard let self = self else { return }
            self.selectedIngredientsRelay.accept(ingredients)
        }
        
        presentMediumModal(viewController)
    }
}
