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
    func fetchIngredients() {
        ingredients.accept(ingredientDAO.fetchAll())
    }
    
    // MARK: - Add Ingredient
    func addIngredient(_ ingredient: RecipeIngredient) {
        if ingredientDAO.insert(ingredient) {
            fetchIngredients()
        }
    }
    
    // MARK: - Update Ingredient
    func updateIngredient(_ ingredient: RecipeIngredient) {
        if ingredientDAO.saveContext() {
            fetchIngredients()
        }
    }
    
    // MARK: - Delete Ingredient
    func deleteIngredient(_ ingredient: RecipeIngredient) {
        if ingredientDAO.delete(ingredient) {
            fetchIngredients()
        }
    }
}
