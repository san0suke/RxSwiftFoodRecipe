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
    
    init(foodRecipeDAO: FoodRecipeDAO = FoodRecipeDAO()) {
        self.foodRecipeDAO = foodRecipeDAO
    }
    
    func save() -> Bool {
        print("Recipe: \(recipeName.value)")
        return false
//        return foodRecipeDAO.insert(recipe)
    }
}
