//
//  MockFoodRecipeDAO.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 19/12/24.
//
//

import Foundation
import CoreData
@testable import RxSwift_Recipes

class MockFoodRecipeDAO: MockBaseDAO, FoodRecipeDAOProtocol {
    
    var createInstanceCompletion: (() -> FoodRecipe)?
    var fetchAllCompletion: (() -> [FoodRecipe])?
    
    func createInstance() -> FoodRecipe {
        return createInstanceCompletion?() ?? FoodRecipe(entity: FoodRecipe.entity(), insertInto: nil)
    }
    
    func fetchAll() -> [FoodRecipe] {
        return fetchAllCompletion?() ?? []
    }
}
