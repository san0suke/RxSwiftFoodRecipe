//
//  FoodRecipeListViewController.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 16/12/24.
//

import UIKit
import RxSwift
import RxCocoa

class FoodRecipeListViewController: UIViewController {
    
    private var tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    private let disposeBag = DisposeBag()
    private let viewModel = FoodRecipeListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Recipes"
        
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
        viewModel.recipes
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { _, recipe, cell in
                cell.textLabel?.text = recipe.name
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelDeleted(FoodRecipe.self)
            .subscribe(onNext: { [weak self] recipe in
                self?.viewModel.delete(recipe)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(FoodRecipe.self)
            .subscribe(onNext: { [weak self] recipe in
                self?.presentEditRecipeForm(for: recipe)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Add Ingredient
    @objc private func didTapAddButton() {
//        let formVC = IngredientFormViewController { [weak self] ingredient in
//            self?.viewModel.add(ingredient)
//        }
//        
//        presentMediumModal(formVC)
    }
//    
//    // MARK: - Edit Ingredient
    private func presentEditRecipeForm(for ingredient: FoodRecipe) {
//        let formVC = IngredientFormViewController(completion: { [weak self] updatedIngredient in
//            self?.viewModel.update(updatedIngredient)
//        }, ingredient: ingredient)
//        
//        presentMediumModal(formVC)
    }
}
