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
        
        let expectation = XCTestExpectation(description: "Fetch ingredients")
        
        viewModel.ingredients
            .skip(1) // Ignora o valor inicial vazio
            .subscribe(onNext: { ingredients in
                XCTAssertEqual(ingredients, expectedIngredients)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        viewModel.fetch()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDeleteIngredient() {
        let ingredientToDelete = RecipeIngredient()
        let remainingIngredients = [RecipeIngredient()]
        
        mockDAO.fetchAllCompletion = {
            remainingIngredients
        }
        
        mockDAO.deleteCompletion = { ingredient in
            XCTAssertEqual(ingredient, ingredientToDelete)
            return true
        }
        
        let expectation = XCTestExpectation(description: "Delete ingredient")
        
        viewModel.ingredients
            .skip(1) // Ignora o valor inicial vazio
            .subscribe(onNext: { ingredients in
                XCTAssertEqual(ingredients, remainingIngredients)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        viewModel.delete(ingredientToDelete)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDeleteIngredientFails() {
        let ingredientToDelete = RecipeIngredient()
        let expectedIngredients = [RecipeIngredient()]
        
        mockDAO.fetchAllCompletion = {
            expectedIngredients
        }
        
        mockDAO.deleteCompletion = { ingredient in
            XCTAssertEqual(ingredient, ingredientToDelete)
            return false
        }
        
        let expectation = XCTestExpectation(description: "Delete ingredient fails")
        
        viewModel.ingredients
            .skip(1) // Ignora o valor inicial vazio
            .subscribe(onNext: { ingredients in
                XCTAssertEqual(ingredients, expectedIngredients)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        viewModel.fetch() // Preenche a lista inicial
        viewModel.delete(ingredientToDelete)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
