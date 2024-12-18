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
    
    private let ingredientDAO: RecipeIngredientDAO
    
    // MARK: - Inputs
    let ingredientName = BehaviorRelay<String>(value: "")
    
    // MARK: - Outputs
    private(set) var isEditing: Bool
    private var ingredient: RecipeIngredient?
    
    // MARK: - Initialization
    init(ingredientDAO: RecipeIngredientDAO = RecipeIngredientDAO(),
        ingredient: RecipeIngredient? = nil) {
        self.ingredientDAO = ingredientDAO
        self.ingredient = ingredient
        self.isEditing = ingredient != nil
        
        if let existingIngredient = ingredient {
            self.ingredientName.accept(existingIngredient.name ?? "")
        }
    }
    
    // MARK: - Create or Update Ingredient
    func save() -> Bool {
        let ingredientToReturn = ingredient ?? ingredientDAO.createInstance()
        ingredientToReturn.name = ingredientName.value
        
        return ingredientDAO.saveContext()
    }
}
