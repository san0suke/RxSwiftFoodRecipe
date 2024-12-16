//
//  IngredientsListViewModel.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 16/12/24.
//

import CoreData

class IngredientsListViewModel {
    
    private let ingredientDao = RecipeIngredientDAO()
    
    var onIngredientsUpdated: (() -> Void)?
    
    // MARK: - Fetch Ingredients
    func fetchIngredients() {
        onIngredientsUpdated?()
    }
    
    // MARK: - Add Ingredient
    func addIngredient(_ ingredient: RecipeIngredient) -> Bool {
        return false
//        let inserted = ingredientDao.insert(name: name)
//        fetchIngredients()
//        return inserted
    }
    
    // MARK: - Update Ingredient
    func updateIngredient(_ ingredient: RecipeIngredient, newName: String) -> Bool {
        return false
//        let success = ingredientDao.update(ingredient: ingredient, newName: newName)
//        fetchIngredients()
//        return success
    }
    
    // MARK: - Delete Ingredient
    func deleteIngredient(_ ingredient: RecipeIngredient) -> Bool {
        return false
//        let success = ingredientDao.delete(ingredient: ingredient)
//        fetchIngredients()
//        return success
    }
}
