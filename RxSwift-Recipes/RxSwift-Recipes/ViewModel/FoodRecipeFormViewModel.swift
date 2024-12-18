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
    
    init(foodRecipe: FoodRecipe? = nil, foodRecipeDAO: FoodRecipeDAO = FoodRecipeDAO()) {
        self.foodRecipeDAO = foodRecipeDAO
        self.foodRecipe = foodRecipe
    }
    
    func save() -> Bool {
        let foodRecipe = foodRecipe ?? FoodRecipe(entity: FoodRecipe.entity(), insertInto: CoreDataManager.shared.persistentContainer.viewContext)
        foodRecipe.name = recipeName.value
        foodRecipe.ingredients = NSSet(array: selectedIngredientsRelay.value)
        
        return foodRecipeDAO.insert(foodRecipe)
    }
    
    func update(_ ingredients: [RecipeIngredient]) {
        self.selectedIngredientsRelay.accept(ingredients)
    }
}
