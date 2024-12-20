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
    
    private var coordinator: IngredientListCoordinatorProtocol
    
    private let tableView: UITableView
    private let disposeBag = DisposeBag()
    private let viewModel: IngredientsListViewModelProtocol
    private let addButtonTappedRelay: PublishRelay<Void>
    private let modelDeletedRelay: PublishRelay<RecipeIngredient>
    private let modelSelectedRelay: PublishRelay<RecipeIngredient>
    
    init(tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped),
         viewModel: IngredientsListViewModelProtocol = IngredientsListViewModel(),
         coordinator: IngredientListCoordinatorProtocol = IngredientListCoordinator(),
         addButtonTappedRelay: PublishRelay<Void> = PublishRelay<Void>(),
         modelDeletedRelay: PublishRelay<RecipeIngredient> = PublishRelay<RecipeIngredient>(),
         modelSelectedRelay: PublishRelay<RecipeIngredient> = PublishRelay<RecipeIngredient>()) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.addButtonTappedRelay = addButtonTappedRelay
        self.modelDeletedRelay = modelDeletedRelay
        self.modelSelectedRelay = modelSelectedRelay
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCoordinator()
        setupUI()
        setupBindings()
        viewModel.fetch()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Ingredients"
        
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupCoordinator() {
        coordinator.navigationController = navigationController
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        navigationItem.rightBarButtonItem?.rx.tap
            .bind(to: addButtonTappedRelay)
            .disposed(by: disposeBag)
        
        addButtonTappedRelay
            .subscribe(onNext: { [weak self] in
                self?.presentIngredientForm(for: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.ingredients
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { _, ingredient, cell in
                cell.textLabel?.text = ingredient.name
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelDeleted(RecipeIngredient.self)
            .bind(to: modelDeletedRelay)
            .disposed(by: disposeBag)
        
        modelDeletedRelay
            .subscribe(onNext: { [weak self] ingredient in
                self?.viewModel.delete(ingredient)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(RecipeIngredient.self)
            .bind(to: modelSelectedRelay)
            .disposed(by: disposeBag)
        
        modelSelectedRelay
            .subscribe(onNext: { [weak self] ingredient in
                self?.presentIngredientForm(for: ingredient)
            })
            .disposed(by: disposeBag)
    }
    
    private func presentIngredientForm(for ingredient: RecipeIngredient?) {
        coordinator.presentIngredientForm(for: ingredient) { [weak self] in
            self?.viewModel.fetch()
        }
    }
}
