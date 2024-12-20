//
//  IngredientListViewController.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 13/12/24.
//

import UIKit
import RxSwift
import RxCocoa

class IngredientListViewController: UIViewController {
    
    private var tableView: UITableView
    private let disposeBag = DisposeBag()
    private let viewModel: IngredientsListViewModelProtocol
    private var coordinator: IngredientListCoordinatorProtocol
    
    init(tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped),
         viewModel: IngredientsListViewModelProtocol = IngredientsListViewModel(),
         coordinator: IngredientListCoordinatorProtocol = IngredientListCoordinator()) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.coordinator = coordinator
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Ingredients"
        
        setupCoordinator()
        setupTableView()
        setupNavigationBar()
        bindTableView()
        
        viewModel.fetch()
    }
    
    private func setupCoordinator() {
        coordinator.navigationController = navigationController
    }
    
    // MARK: - Setup UI
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Bind TableView
    private func bindTableView() {
        viewModel.ingredients
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { _, ingredient, cell in
                cell.textLabel?.text = ingredient.name
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelDeleted(RecipeIngredient.self)
            .subscribe(onNext: { [weak self] ingredient in
                self?.viewModel.delete(ingredient)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(RecipeIngredient.self)
            .subscribe(onNext: { [weak self] ingredient in
                self?.presentIngredientForm(for: ingredient)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Add Ingredient
    @objc private func didTapAddButton() {
        presentIngredientForm(for: nil)
    }
    
    private func presentIngredientForm(for ingredient: RecipeIngredient?) {
        coordinator.presentIngredientForm(for: ingredient) { [weak self] in
            self?.viewModel.fetch()
        }
    }
}
