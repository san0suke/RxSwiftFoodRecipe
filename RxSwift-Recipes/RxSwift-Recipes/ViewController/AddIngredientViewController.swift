//
//  AddIngredientViewController.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 14/12/24.
//

import UIKit

class AddIngredientViewController: UIViewController {
    
    private let completion: (String) -> Void

    private let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Ingredient name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    init(completion: @escaping (String) -> Void) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Add Ingredient"
        setupUI()
    }

    private func setupUI() {
        view.addSubview(textField)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton))

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc private func didTapSaveButton() {
        guard let ingredientName = textField.text, !ingredientName.isEmpty else { return }
        completion(ingredientName)
        dismiss(animated: true, completion: nil)
    }

    @objc private func didTapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
}
