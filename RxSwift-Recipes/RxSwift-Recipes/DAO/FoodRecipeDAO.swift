//
//  FoodRecipeDAO.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 16/12/24.
//

import CoreData

class FoodRecipeDAO: BaseDAO {
    
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
