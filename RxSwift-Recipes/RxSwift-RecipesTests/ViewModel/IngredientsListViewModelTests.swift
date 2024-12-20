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

class IngredientsListViewModelTests: XCTestCase {
    
    var viewModel: IngredientsListViewModel!
    var mockDAO: MockRecipeIngredientDAO!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        mockDAO = MockRecipeIngredientDAO()
        viewModel = IngredientsListViewModel(ingredientDAO: mockDAO)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        viewModel = nil
        mockDAO = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testFetchIngredients() {
        let expectedIngredients = [
            RecipeIngredient(),
            RecipeIngredient()
        ]
        
        mockDAO.fetchAllCompletion = {
            expectedIngredients
        }
        
        let fetchExpectation = expectation(description: "Should fetch")
        
        viewModel.ingredients
            .skip(1)
            .subscribe(onNext: { ingredients in
                XCTAssertEqual(ingredients, expectedIngredients)
                fetchExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        viewModel.fetch()
        
        waitForExpectations(timeout: 3)
    }
    
    func testDeleteIngredient() {
        let ingredientToDelete = RecipeIngredient()
        let remainingIngredients = [RecipeIngredient()]
        
        let deleteExpectation = expectation(description: "Should delete")
        let fetchExpectation = expectation(description: "Should fetch")
        
        mockDAO.fetchAllCompletion = {
            remainingIngredients
        }
        
        mockDAO.deleteCompletion = { ingredient in
            XCTAssertEqual(ingredient, ingredientToDelete)
            deleteExpectation.fulfill()
            return true
        }
        
        viewModel.ingredients
            .skip(1)
            .subscribe(onNext: { ingredients in
                XCTAssertEqual(ingredients, remainingIngredients)
                fetchExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        viewModel.delete(ingredientToDelete)
        
        waitForExpectations(timeout: 3)
    }

    func testDeleteIngredientFails() {
        let ingredientToDelete = RecipeIngredient()
        let expectedIngredients = [RecipeIngredient()]
        
        let deleteExpectation = expectation(description: "Should call delete")
        let fetchExpectation = expectation(description: "Should not call fetch")
        fetchExpectation.isInverted = true
        
        mockDAO.fetchAllCompletion = {
            fetchExpectation.fulfill()
            return expectedIngredients
        }
        
        mockDAO.deleteCompletion = { ingredient in
            XCTAssertEqual(ingredient, ingredientToDelete)
            deleteExpectation.fulfill()
            return false
        }
        
        viewModel.delete(ingredientToDelete)
        
        waitForExpectations(timeout: 1)
    }
}
