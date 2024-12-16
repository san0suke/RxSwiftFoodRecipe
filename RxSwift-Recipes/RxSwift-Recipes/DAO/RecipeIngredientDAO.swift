//
//  RecipeIngredientDAO.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 14/12/24.
//

import CoreData

class RecipeIngredientDAO {

    // MARK: - Properties
    private let context: NSManagedObjectContext

    // MARK: - Initialization
    init(context: NSManagedObjectContext = CoreDataManager.shared.persistentContainer.viewContext) {
        self.context = context
    }
    
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

    func fetchByName(_ name: String) -> [RecipeIngredient] {
        let fetchRequest: NSFetchRequest<RecipeIngredient> = RecipeIngredient.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch RecipeIngredients by name: \(error)")
            return []
        }
    }
    
    func insert(_ ingredient: RecipeIngredient) -> Bool {
        context.insertAndSave(ingredient)
    }

    // MARK: - Delete
    func delete(ingredient: RecipeIngredient) -> Bool {
        context.deleteAndSave(ingredient)
    }
}
