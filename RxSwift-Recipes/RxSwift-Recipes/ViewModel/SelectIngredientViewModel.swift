//
//  SelectIngredientViewModel.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 18/12/24.
//

import Foundation
import RxSwift
import RxCocoa

class SelectIngredientViewModel {
    
    private let ingredientsDAO: RecipeIngredientDAO
    private(set) var ingredients = BehaviorRelay<[RecipeIngredient]>(value: [])
    private(set) var selectedIngredients = BehaviorRelay<Set<RecipeIngredient>>(value: [])
    
    init(selectedIngredients: [RecipeIngredient],
         ingredientsDAO: RecipeIngredientDAO = RecipeIngredientDAO()) {
        self.selectedIngredients.accept(Set(selectedIngredients))
        self.ingredientsDAO = ingredientsDAO
    }
    
    // MARK: - Fetch Ingredients
     func fetch() {
        ingredients.accept(ingredientsDAO.fetchAll())
    }
    
    func contains(_ ingredient: RecipeIngredient) -> Bool {
        return selectedIngredients.value.contains(ingredient)
    }
    
    func onRowPressed(_ ingredient: RecipeIngredient) {
        if contains(ingredient) {
            remove(ingredient)
        } else {
            add(ingredient)
        }
    }
    
    private func add(_ ingredient: RecipeIngredient) {
        var ingredients = selectedIngredients.value
        ingredients.insert(ingredient)
        selectedIngredients.accept(ingredients)
    }
    
    private func remove(_ ingredient: RecipeIngredient) {
        var ingredients = selectedIngredients.value
        ingredients.remove(ingredient)
        selectedIngredients.accept(ingredients)
    }
}
