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

    // MARK: - Insert
    func insert(name: String) -> RecipeIngredient? {
        let ingredient = RecipeIngredient(context: context)
        ingredient.name = name

        do {
            try context.save()
            return ingredient
        } catch {
            print("Failed to insert RecipeIngredient: \(error)")
            return nil
        }
    }

    // MARK: - Update
    func update(ingredient: RecipeIngredient, newName: String) -> Bool {
        ingredient.name = newName

        do {
            try context.save()
            return true
        } catch {
            print("Failed to update RecipeIngredient: \(error)")
            return false
        }
    }

    // MARK: - Delete
    func delete(ingredient: RecipeIngredient) -> Bool {
        context.delete(ingredient)

        do {
            try context.save()
            return true
        } catch {
            print("Failed to delete RecipeIngredient: \(error)")
            return false
        }
    }
}
