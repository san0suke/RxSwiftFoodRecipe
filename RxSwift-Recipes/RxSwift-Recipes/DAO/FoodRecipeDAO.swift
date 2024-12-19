//
//  FoodRecipeDAO.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 16/12/24.
//

import CoreData

protocol FoodRecipeDAOProtocol {
    func createInstance() -> FoodRecipe
    func fetchAll() -> [FoodRecipe]
}

class FoodRecipeDAO: BaseDAO, FoodRecipeDAOProtocol {
    
    func createInstance() -> FoodRecipe {
        FoodRecipe(entity: FoodRecipe.entity(), insertInto: context)
    }
    
    // MARK: - Fetch All
    func fetchAll() -> [FoodRecipe] {
        let fetchRequest: NSFetchRequest<FoodRecipe> = FoodRecipe.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch FoodRecipes: \(error)")
            return []
        }
    }
}
