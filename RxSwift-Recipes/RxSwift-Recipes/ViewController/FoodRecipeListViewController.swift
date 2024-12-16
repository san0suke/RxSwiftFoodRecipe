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
//        
//        setupTableView()
//        setupNavigationBar()
//        bindTableView()
//        
//        viewModel.fetchIngredients()
    }
    
//    // MARK: - Setup UI
//    private func setupNavigationBar() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
//    }
//    
//    private func setupTableView() {
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "IngredientCell")
//        
//        view.addSubview(tableView)
//        
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    // MARK: - Bind TableView
//    private func bindTableView() {
//        // Binding: ViewModel -> TableView
//        viewModel.ingredients
//            .bind(to: tableView.rx.items(cellIdentifier: "IngredientCell")) { _, ingredient, cell in
//                cell.textLabel?.text = ingredient.name
//            }
//            .disposed(by: disposeBag)
//        
//        // Handling delete action
//        tableView.rx.modelDeleted(RecipeIngredient.self)
//            .subscribe(onNext: { [weak self] ingredient in
//                self?.viewModel.deleteIngredient(ingredient)
//            })
//            .disposed(by: disposeBag)
//        
//        // Handling row selection for editing
//        tableView.rx.modelSelected(RecipeIngredient.self)
//            .subscribe(onNext: { [weak self] ingredient in
//                self?.presentEditIngredientForm(for: ingredient)
//            })
//            .disposed(by: disposeBag)
//    }
//    
//    // MARK: - Add Ingredient
//    @objc private func didTapAddButton() {
//        let formVC = IngredientFormViewController { [weak self] ingredient in
//            self?.viewModel.addIngredient(ingredient)
//        }
//        
//        presentMediumModal(formVC)
//    }
//    
//    // MARK: - Edit Ingredient
//    private func presentEditIngredientForm(for ingredient: RecipeIngredient) {
//        let formVC = IngredientFormViewController(completion: { [weak self] updatedIngredient in
//            self?.viewModel.updateIngredient(updatedIngredient)
//        }, ingredient: ingredient)
//        
//        presentMediumModal(formVC)
//    }
}
