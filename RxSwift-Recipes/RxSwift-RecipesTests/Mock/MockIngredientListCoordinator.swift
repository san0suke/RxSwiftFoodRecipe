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
    
    var presentIngredientFormCalled = false
    var presentedIngredient: RecipeIngredient?
    var presentIngredientFormCompletion: (() -> Void)?
    
    func presentIngredientForm(for ingredient: RecipeIngredient?, completion: @escaping () -> Void) {
        presentIngredientFormCalled = true
        presentedIngredient = ingredient
        presentIngredientFormCompletion = completion
    }
}
