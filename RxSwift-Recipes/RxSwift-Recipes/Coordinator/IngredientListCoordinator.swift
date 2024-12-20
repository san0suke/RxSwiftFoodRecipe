//
//  IngredientListCoordinator.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 20/12/24.
//

import UIKit

protocol IngredientListCoordinatorProtocol {
    var navigationController: UINavigationController? { get set }
    func presentIngredientForm(for ingredient: RecipeIngredient?, completion: @escaping () -> Void)
}

class IngredientListCoordinator: IngredientListCoordinatorProtocol {
    
    weak var navigationController: UINavigationController?
    
    func presentIngredientForm(for ingredient: RecipeIngredient?, completion: @escaping () -> Void) {
        let viewController = IngredientFormViewController(completion: completion, ingredient: ingredient)
        navigationController?.presentMediumModal(viewController)
    }
}
