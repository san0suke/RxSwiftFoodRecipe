//
//  MockIngredientListCoordinator.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 20/12/24.
//

import UIKit
@testable import RxSwift_Recipes

class MockIngredientListCoordinator: IngredientListCoordinatorProtocol {
    
    var navigationController: UINavigationController?
    
    var presentIngredientFormCompletion: ((_ ingredient: RecipeIngredient?, _ completion: () -> Void) -> Void)?
    
    func presentIngredientForm(for ingredient: RecipeIngredient?, completion: @escaping () -> Void) {
        presentIngredientFormCompletion?(ingredient, completion)
    }
}
