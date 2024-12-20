//
//  IngredientsListViewModel.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 16/12/24.
//

import RxSwift
import RxCocoa
import CoreData

class IngredientsListViewModel {
    
    private let ingredientDAO: RecipeIngredientDAOProtocol
    
    let ingredients: BehaviorRelay<[RecipeIngredient]> = BehaviorRelay(value: [])
    
    init(ingredientDAO: RecipeIngredientDAOProtocol = RecipeIngredientDAO()) {
        self.ingredientDAO = ingredientDAO
    }
    
    // MARK: - Fetch Ingredients
    func fetch() {
        ingredients.accept(ingredientDAO.fetchAll())
    }
    
    // MARK: - Delete Ingredient
    func delete(_ ingredient: RecipeIngredient) {
        if ingredientDAO.delete(ingredient) {
            fetch()
        }
    }
}
