//
//  MockRecipeIngredientDAO.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 19/12/24.
//

import Foundation
import CoreData
@testable import RxSwift_Recipes

class MockRecipeIngredientDAO: MockBaseDAO, RecipeIngredientDAOProtocol {
    
    var createInstanceCompletion: (() -> RecipeIngredient)?
    var fetchAllCompletion: (() -> [RecipeIngredient])?
    
    func createInstance() -> RecipeIngredient {
        return createInstanceCompletion?() ?? RecipeIngredient(entity: RecipeIngredient.entity(), insertInto: nil)
    }
    
    func fetchAll() -> [RecipeIngredient] {
        return fetchAllCompletion?() ?? []
    }
}
