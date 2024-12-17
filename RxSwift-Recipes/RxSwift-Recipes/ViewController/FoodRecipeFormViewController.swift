//
//  FoodRecipeFormViewController.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 16/12/24.
//

import UIKit
import CoreData

class FoodRecipeFormViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let nameContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Recipe Name"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Recipe Name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        title = "Add Recipe"
        
        setupScrollView()
        setupStackView()
    }
    
    // MARK: - Setup Methods
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private func setupStackView() {
        // Adiciona o container com a label e o textField
        setupNameContainerView()
        
        // Adiciona o container ao stackView
        stackView.addArrangedSubview(nameContainerView)
    }
    
    private func setupNameContainerView() {
        nameContainerView.addSubview(subtitleLabel)
        nameContainerView.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            // Subtitle Label
            subtitleLabel.topAnchor.constraint(equalTo: nameContainerView.topAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: nameContainerView.leadingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: nameContainerView.trailingAnchor, constant: -8),
            
            // Name TextField
            nameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: nameContainerView.leadingAnchor, constant: 8),
            nameTextField.trailingAnchor.constraint(equalTo: nameContainerView.trailingAnchor, constant: -8),
            nameTextField.bottomAnchor.constraint(equalTo: nameContainerView.bottomAnchor, constant: -8),
            nameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
