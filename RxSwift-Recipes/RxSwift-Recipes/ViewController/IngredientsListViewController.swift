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
    private var dataSource: UITableViewDiffableDataSource<Int, RecipeIngredient>!
    private let ingredientDao = RecipeIngredientDAO()

    private var ingredients: [RecipeIngredient] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Ingredients"
        
        setupTableView()
        setupDataSource()
        setupNavigationBar()
        fetchIngredients()
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
        dataSource = UITableViewDiffableDataSource<Int, RecipeIngredient>(tableView: tableView) { tableView, indexPath, ingredient in
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell") ?? UITableViewCell(style: .default, reuseIdentifier: "IngredientCell")
            cell.textLabel?.text = ingredient.name
            return cell
        }
        dataSource.defaultRowAnimation = .fade
        tableView.delegate = self
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, RecipeIngredient>()
        snapshot.appendSections([0])
        snapshot.appendItems(ingredients)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func deleteIngredient(at indexPath: IndexPath) {
        guard let ingredient = dataSource.itemIdentifier(for: indexPath) else { return }
        
        ingredients.removeAll { $0 == ingredient }
        applySnapshot()
    }
    
    private func fetchIngredients() {
        ingredients = ingredientDao.fetchAll()
        applySnapshot()
    }
    
    @objc private func didTapAddButton() {
        let addIngredientVC = AddIngredientViewController { [weak self] newIngredient in
            guard let self = self else { return }
            if let insertedIngredient = ingredientDao.insert(name: newIngredient) {
                self.ingredients.append(insertedIngredient)
                self.applySnapshot()
            }
        }
        
        let navigationController = UINavigationController(rootViewController: addIngredientVC)
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
                self.ingredients.removeAll { $0 == ingredient }
                self.applySnapshot()
            }
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
