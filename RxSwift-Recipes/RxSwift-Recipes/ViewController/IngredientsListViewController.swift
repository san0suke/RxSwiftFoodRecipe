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
    
    private lazy var snapshot: NSDiffableDataSourceSnapshot<Int, RecipeIngredient> = {
        NSDiffableDataSourceSnapshot<Int, RecipeIngredient>()
    }()
    
    private let ingredientDao = RecipeIngredientDAO()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Ingredients"
        
        setupTableView()
        setupDataSource()
        setupNavigationBar()
        applySnapshot()
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

    private func applySnapshot() {
        snapshot.appendSections([0])
        snapshot.appendItems(ingredientDao.fetchAll())
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc private func didTapAddButton() {
        let viewController = IngredientFormViewController { [weak self] ingredient in
            guard let self = self else { return }
            
            if ingredientDao.saveContext() {
                snapshot.appendItems([ingredient])
                dataSource.apply(snapshot, animatingDifferences: true)
            }
        }
        
        presentIngredientFormVC(viewController)
    }
    
    private func presentIngredientFormVC(_ viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .pageSheet
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(navigationController, animated: true, completion: nil)
    }
}

extension IngredientsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let ingredient = dataSource.itemIdentifier(for: indexPath) else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let self = self else { return }
            
            if ingredientDao.delete(ingredient: ingredient) {
                snapshot.deleteItems([ingredient])
                dataSource.apply(snapshot, animatingDifferences: true)
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
                snapshot.reloadItems([ingredient])
                dataSource.apply(snapshot, animatingDifferences: true)
            }
        }, ingredient: ingredient)
        presentIngredientFormVC(editIngredientVC)
    }
}
