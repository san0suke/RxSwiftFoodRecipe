//
//  SelectIngredientViewController.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 17/12/24.
//

import UIKit
import CoreData

class SelectIngredientViewController: UIViewController {
    
    // MARK: - UI Components
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var ingredients: [RecipeIngredient] = []
    private var selectedIngredients: Set<RecipeIngredient> = []
    
    private let completion: ([RecipeIngredient]) -> Void
    
    // MARK: - Initialization
    init(selected: [RecipeIngredient] = [], completion: @escaping ([RecipeIngredient]) -> Void) {
        self.selectedIngredients = Set(selected)
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Ingredients"
        view.backgroundColor = .white
        
        setupTableView()
        setupNavigationBar()
        fetchIngredients()
    }
    
    // MARK: - Setup UI
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "IngredientCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton))
    }
    
    // MARK: - Fetch Ingredients
    private func fetchIngredients() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<RecipeIngredient> = RecipeIngredient.fetchRequest()
        
        do {
            ingredients = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Failed to fetch ingredients: \(error)")
        }
    }
    
    // MARK: - Actions
    @objc private func didTapDoneButton() {
        completion(Array(selectedIngredients))
        dismiss(animated: true)
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension SelectIngredientViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        let ingredient = ingredients[indexPath.row]
        
        cell.textLabel?.text = ingredient.name ?? "Unnamed Ingredient"
        
        if selectedIngredients.contains(ingredient) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredient = ingredients[indexPath.row]
        
        if selectedIngredients.contains(ingredient) {
            selectedIngredients.remove(ingredient)
        } else {
            selectedIngredients.insert(ingredient)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

