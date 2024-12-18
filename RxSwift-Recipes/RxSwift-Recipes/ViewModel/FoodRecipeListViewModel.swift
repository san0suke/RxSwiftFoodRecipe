//
//  FoodRecipeListViewModel.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 16/12/24.
//

import RxSwift
import RxCocoa

class FoodRecipeListViewModel {
    
    private let recipeDAO = FoodRecipeDAO()
    
    let recipes: BehaviorRelay<[FoodRecipe]> = BehaviorRelay(value: [])
    
    func fetch() {
        recipes.accept(recipeDAO.fetchAll())
    }
    
    func delete(_ ingredient: FoodRecipe) {
        if recipeDAO.delete(ingredient) {
            fetch()
        }
    }
}
