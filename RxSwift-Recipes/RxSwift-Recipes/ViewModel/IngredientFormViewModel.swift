//
//  IngredientFormViewModel.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 16/12/24.
//

import Foundation
import RxSwift
import RxCocoa

class IngredientFormViewModel {
    
    // MARK: - Inputs
    let ingredientName = BehaviorRelay<String>(value: "")
    
    // MARK: - Outputs
    private(set) var isEditing: Bool
    private var ingredient: RecipeIngredient?
    
    // MARK: - Initialization
    init(ingredient: RecipeIngredient? = nil) {
        self.ingredient = ingredient
        self.isEditing = ingredient != nil
        
        if let existingIngredient = ingredient {
            self.ingredientName.accept(existingIngredient.name ?? "")
        }
    }
    
    // MARK: - Create or Update Ingredient
    func getUpdatedIngredient() -> RecipeIngredient {
        let ingredientToReturn = ingredient ?? RecipeIngredient(entity: RecipeIngredient.entity(), insertInto: nil)
        ingredientToReturn.name = ingredientName.value
        return ingredientToReturn
    }
}
