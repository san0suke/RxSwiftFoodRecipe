//
//  IngredientsListViewModel.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 16/12/24.
//

import RxSwift
import RxCocoa
import CoreData

protocol IngredientsListViewModelProtocol {
    var ingredients: BehaviorRelay<[RecipeIngredient]> { get set }
    func fetch()
    func delete(_ ingredient: RecipeIngredient)
}

class IngredientsListViewModel: IngredientsListViewModelProtocol {
    
    private let ingredientDAO: RecipeIngredientDAOProtocol
    
    var ingredients: BehaviorRelay<[RecipeIngredient]> = BehaviorRelay(value: [])
    
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
