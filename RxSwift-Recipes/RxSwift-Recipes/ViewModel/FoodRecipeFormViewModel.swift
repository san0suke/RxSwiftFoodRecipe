//
//  FoodRecipeFormViewModel.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 17/12/24.
//

import Foundation
import RxSwift
import RxCocoa

class FoodRecipeFormViewModel {
    
    let foodRecipeDAO: FoodRecipeDAO
    var foodRecipe: FoodRecipe?
    
    let recipeName = BehaviorRelay<String>(value: "")
    let selectedIngredientsRelay = BehaviorRelay<[RecipeIngredient]>(value: [])
    
    lazy var isSaveButtonEnabled: Observable<Bool> = {
        return Observable.combineLatest(recipeName, selectedIngredientsRelay)
            .map { name, ingredients in
                return !name.isEmpty && !ingredients.isEmpty
            }
            .distinctUntilChanged()
    }()
    
    init(foodRecipe: FoodRecipe? = nil, foodRecipeDAO: FoodRecipeDAO = FoodRecipeDAO()) {
        self.foodRecipeDAO = foodRecipeDAO
        self.foodRecipe = foodRecipe
    }
    
    func save() -> Bool {
        let foodRecipe = foodRecipe ?? foodRecipeDAO.createInstance()
        foodRecipe.name = recipeName.value
        foodRecipe.ingredients = NSSet(array: selectedIngredientsRelay.value)
        
        return foodRecipeDAO.insert(foodRecipe)
    }
    
    func update(_ ingredients: [RecipeIngredient]) {
        self.selectedIngredientsRelay.accept(ingredients)
    }
}
