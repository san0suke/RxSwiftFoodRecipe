//
//  IngredientListViewControllerTests.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 20/12/24.
//

import XCTest
import RxSwift
import RxCocoa
@testable import RxSwift_Recipes

class IngredientListViewControllerTests: XCTestCase {
    
    var viewController: IngredientListViewController!
    var mockViewModel: MockIngredientsListViewModel!
    var mockCoordinator: MockIngredientListCoordinator!
    var mockTableView: UITableView!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        
        mockViewModel = MockIngredientsListViewModel()
        mockCoordinator = MockIngredientListCoordinator()
        mockTableView = UITableView()
        disposeBag = DisposeBag()
        
        viewController = IngredientListViewController(
            tableView: mockTableView,
            viewModel: mockViewModel,
            coordinator: mockCoordinator
        )
        
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        mockCoordinator = nil
        mockTableView = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testViewDidLoad_TriggersFetchOnViewModel() {
        var fetchCalled = false
        
        mockViewModel.fetchCompletion = {
            fetchCalled = true
        }
        
        viewController.viewDidLoad()
        
        XCTAssertTrue(fetchCalled, "fetch() should be called when viewDidLoad is executed")
    }
    
    func testDidTapAddButton_CallsCoordinatorPresentIngredientForm() {
        let expectation = expectation(description: "Coordinator's presentIngredientForm should be called")
        
        mockCoordinator.presentIngredientFormCompletion = { ingredient, completion in
            XCTAssertNil(ingredient, "Ingredient should be nil when adding a new ingredient")
            completion()
            expectation.fulfill()
        }
        
        viewController.didTapAddButton()
        
        waitForExpectations(timeout: 1)
    }
    
//    func testModelDeleted_CallsViewModelDelete() {
//        let testIngredient = RecipeIngredient()
//        let expectation = expectation(description: "ViewModel's delete should be called")
//        
//        mockViewModel.deleteCompletion = { ingredient in
//            XCTAssertEqual(ingredient, testIngredient, "The deleted ingredient should match the selected one")
//            expectation.fulfill()
//        }
//        
//        mockTableView.rx.modelDeleted(RecipeIngredient.self).onNext(testIngredient)
//        
//        waitForExpectations(timeout: 1)
//    }
//    
//    func testModelSelected_CallsCoordinatorPresentIngredientForm() {
//        let testIngredient = RecipeIngredient()
//        let expectation = expectation(description: "Coordinator's presentIngredientForm should be called with the selected ingredient")
//        
//        mockCoordinator.presentIngredientFormCompletion = { ingredient, completion in
//            XCTAssertEqual(ingredient, testIngredient, "The selected ingredient should be passed to the coordinator")
//            completion()
//            expectation.fulfill()
//        }
//        
//        mockTableView.rx.modelSelected(RecipeIngredient.self).onNext(testIngredient)
//        
//        waitForExpectations(timeout: 1)
//    }
}
