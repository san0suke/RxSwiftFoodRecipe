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
    
    private let ingredientDAO = RecipeIngredientDAO()
    
    // Observable com os ingredientes
    let ingredients: BehaviorRelay<[RecipeIngredient]> = BehaviorRelay(value: [])
    
    // MARK: - Fetch Ingredients
    func fetch() {
        ingredients.accept(ingredientDAO.fetchAll())
    }
    
    // MARK: - Update Ingredient
    func update() {
        if ingredientDAO.saveContext() {
            fetch()
        }
    }
    
    // MARK: - Delete Ingredient
    func delete(_ ingredient: RecipeIngredient) {
        if ingredientDAO.delete(ingredient) {
            fetch()
        }
    }
}
