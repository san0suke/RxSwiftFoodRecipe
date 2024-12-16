//
//  IngredientsListViewController.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 13/12/24.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa

class IngredientsListViewController: UIViewController {

    private var tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    private let disposeBag = DisposeBag()
    private let ingredientDAO = RecipeIngredientDAO()
    
    private let ingredientsRelay = BehaviorRelay<[RecipeIngredient]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Ingredients"
        
        setupTableView()
        setupNavigationBar()
        bindTableView()
        fetchIngredients()
    }
    
    // MARK: - Setup UI
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "IngredientCell")
        
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
        ingredientsRelay
            .bind(to: tableView.rx.items(cellIdentifier: "IngredientCell")) { _, ingredient, cell in
                cell.textLabel?.text = ingredient.name
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelDeleted(RecipeIngredient.self)
            .subscribe(onNext: { [weak self] ingredient in
                self?.deleteIngredient(ingredient)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(RecipeIngredient.self)
            .subscribe(onNext: { [weak self] ingredient in
                self?.presentEditIngredientForm(for: ingredient)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Fetch Ingredients
    private func fetchIngredients() {
        ingredientsRelay.accept(ingredientDAO.fetchAll())
    }
    
    // MARK: - Add Ingredient
    @objc private func didTapAddButton() {
        let formVC = IngredientFormViewController { [weak self] ingredient in
            guard let self = self else { return }
            if self.ingredientDAO.insert(ingredient) {
                self.fetchIngredients()
            }
        }
        presentMediumModal(formVC)
    }
    
    // MARK: - Delete Ingredient
    private func deleteIngredient(_ ingredient: RecipeIngredient) {
        if ingredientDAO.delete(ingredient: ingredient) {
            fetchIngredients()
        }
    }
    
    // MARK: - Edit Ingredient
    private func presentEditIngredientForm(for ingredient: RecipeIngredient) {
        let formVC = IngredientFormViewController(completion: { [weak self] updatedIngredient in
            guard let self = self else { return }
            if self.ingredientDAO.saveContext() {
                self.fetchIngredients()
            }
        }, ingredient: ingredient)
        presentMediumModal(formVC)
    }
}
