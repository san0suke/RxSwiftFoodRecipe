//
//  IngredientListCoordinatorTests.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 20/12/24.
//

import XCTest
import CoreData
@testable import RxSwift_Recipes

class IngredientListCoordinatorTests: XCTestCase {
    
    var coordinator: IngredientListCoordinator!
    var mockNavigationController: MockNavigationController!
    var mockPersistentContainer: MockNSPersistentContainer!
    var mockContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()

        mockPersistentContainer = MockNSPersistentContainer(modelName: "RxSwift_Recipes")
        mockContext = mockPersistentContainer.viewContext
        
        mockNavigationController = MockNavigationController()
        
        coordinator = IngredientListCoordinator()
        coordinator.navigationController = mockNavigationController
    }

    override func tearDown() {
        coordinator = nil
        mockNavigationController = nil
        mockPersistentContainer = nil
        mockContext = nil
        super.tearDown()
    }

    func testPresentIngredientFormCallsPresentMediumModal() {
        let ingredient = RecipeIngredient(context: mockContext)
        ingredient.name = "Test Ingredient"
        let presentExpectation = expectation(description: "presentMediumModal should be called")

        mockNavigationController.presentMediumModalCompletion = { viewController in
            XCTAssertTrue(viewController is IngredientFormViewController)
            XCTAssertNotNil(viewController)
            presentExpectation.fulfill()
        }
        
        coordinator.presentIngredientForm(for: ingredient) {}
        wait(for: [presentExpectation], timeout: 1)
    }
}

