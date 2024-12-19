//
//  IngredientsListViewModelTests.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 19/12/24.
//

import XCTest
import RxSwift
import RxCocoa
@testable import RxSwift_Recipes

//class IngredientsListViewModelTests: XCTestCase {
//    
//    private var viewModel: IngredientsListViewModel!
//    private var ingredientDAO: MockRecipeIngredientDAO!
//    private var disposeBag: DisposeBag!
//    
//    override func setUp() {
//        super.setUp()
//        ingredientDAO = MockRecipeIngredientDAO()
//        viewModel = IngredientsListViewModel(ingredientDAO: ingredientDAO)
//        disposeBag = DisposeBag()
//    }
//    
//    override func tearDown() {
//        disposeBag = nil
//        ingredientDAO = nil
//        viewModel = nil
//        super.tearDown()
//    }
//    
//    func testFetchIngredients() {
//        // Arrange
//        let expectedIngredients = [
//            RecipeIngredient(name: "Salt"),
//            RecipeIngredient(name: "Pepper"),
//            RecipeIngredient(name: "Garlic")
//        ]
//        ingredientDAO.mockIngredients = expectedIngredients
//        
//        // Act
//        viewModel.fetch()
//        
//        // Assert
//        XCTAssertEqual(viewModel.ingredients.value, expectedIngredients)
//    }
//    
//    func testDeleteIngredient() {
//        // Arrange
//        let ingredientToDelete = RecipeIngredient(name: "Salt")
//        let initialIngredients = [
//            ingredientToDelete,
//            RecipeIngredient(name: "Pepper"),
//            RecipeIngredient(name: "Garlic")
//        ]
//        ingredientDAO.mockIngredients = initialIngredients
//        
//        // Act
//        viewModel.delete(ingredientToDelete)
//        
//        // Assert
//        XCTAssertFalse(viewModel.ingredients.value.contains(ingredientToDelete))
//        XCTAssertEqual(viewModel.ingredients.value.count, 2)
//    }
//}
