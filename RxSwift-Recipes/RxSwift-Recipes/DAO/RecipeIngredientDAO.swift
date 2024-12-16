//
//  RecipeIngredientDAO.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 14/12/24.
//

import CoreData

class RecipeIngredientDAO: BaseDAO {

    // MARK: - Fetch
    func fetchAll() -> [RecipeIngredient] {
        let fetchRequest: NSFetchRequest<RecipeIngredient> = RecipeIngredient.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch RecipeIngredients: \(error)")
            return []
        }
    }
}
