//
//  addViewController.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 14/12/24.
//

import UIKit
import RxSwift
import RxCocoa

class IngredientFormViewController: UIViewController {
    
    private let viewModel: IngredientFormViewModel
    private let completion: () -> Void
    private let disposeBag = DisposeBag()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Ingredient name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var saveButton: UIBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: nil, action: nil)
    
    // MARK: - Initialization
    init(completion: @escaping () -> Void, ingredient: RecipeIngredient? = nil) {
        self.completion = completion
        self.viewModel = IngredientFormViewModel(ingredient: ingredient)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = viewModel.isEditing ? "Edit Ingredient" : "Add Ingredient"
        
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.addSubview(textField)
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton))
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func bindViewModel() {
        viewModel.ingredientName
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
        
        textField.rx.text.orEmpty
            .bind(to: viewModel.ingredientName)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didTapSaveButton()
            })
            .disposed(by: disposeBag)
        
        viewModel.isSaveButtonEnabled
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    // MARK: - Actions
    private func didTapSaveButton() {
        if viewModel.save() {
            completion()
            dismiss(animated: true, completion: nil)
        }
    }

    @objc private func didTapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
}

