//
//  IngredientsListViewController.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 13/12/24.
//

import UIKit
import CoreData

class IngredientsListViewController: UIViewController {

    private var tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, RecipeIngredient> = {
        UITableViewDiffableDataSource<Int, RecipeIngredient>(tableView: tableView) { tableView, indexPath, ingredient in
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell") ?? UITableViewCell(style: .default, reuseIdentifier: "IngredientCell")
            cell.textLabel?.text = ingredient.name
            return cell
        }
    }()
    
    private let ingredientDao = RecipeIngredientDAO()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Ingredients"
        
        setupTableView()
        setupDataSource()
        setupNavigationBar()
        reloadTable()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupDataSource() {
        dataSource.defaultRowAnimation = .fade
        tableView.delegate = self
    }

    private func reloadTable(ingredient: RecipeIngredient? = nil) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, RecipeIngredient>()
        snapshot.appendSections([0])
        snapshot.appendItems(ingredientDao.fetchAll())
        
        if let ingredient = ingredient {
            snapshot.reloadItems([ingredient])
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc private func didTapAddButton() {
        let viewController = IngredientFormViewController { [weak self] ingredient in
            guard let self = self else { return }
            
            if ingredientDao.saveContext() {
                reloadTable()
            }
        }
        
        presentMediumModal(viewController)
    }
}

extension IngredientsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let ingredient = dataSource.itemIdentifier(for: indexPath) else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let self = self else { return }
            
            if ingredientDao.delete(ingredient: ingredient) {
                dataSource.delete(item: ingredient)
            }
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let ingredient = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let editIngredientVC = IngredientFormViewController(completion: { [weak self] ingredient in
            guard let self = self else { return }
            
            if ingredientDao.saveContext() {
                reloadTable(ingredient: ingredient)
            }
        }, ingredient: ingredient)
        
        presentMediumModal(editIngredientVC)
    }
}
