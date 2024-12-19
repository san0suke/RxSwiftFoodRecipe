//
//  IngredientsListViewController.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 13/12/24.
//

import UIKit
import RxSwift
import RxCocoa

class IngredientsListViewController: UIViewController {
    
    private var tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    private let disposeBag = DisposeBag()
    private let viewModel = IngredientsListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Ingredients"
        
        setupTableView()
        setupNavigationBar()
        bindTableView()
        
        viewModel.fetch()
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
                self?.presentEditIngredientForm(for: ingredient)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Add Ingredient
    @objc private func didTapAddButton() {
        let formVC = IngredientFormViewController { [weak self] in
            self?.viewModel.fetch()
        }
        
        presentMediumModal(formVC)
    }
    
    // MARK: - Edit Ingredient
    private func presentEditIngredientForm(for ingredient: RecipeIngredient) {
        let formVC = IngredientFormViewController(completion: { [weak self] in
            self?.viewModel.fetch()
        }, ingredient: ingredient)
        
        presentMediumModal(formVC)
    }
}
