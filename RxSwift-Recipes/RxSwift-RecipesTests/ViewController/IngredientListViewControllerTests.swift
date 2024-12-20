//
//  IngredientListViewControllerTests.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 20/12/24.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import RxSwift_Recipes

class IngredientListViewControllerTests: XCTestCase {
    
    var viewController: IngredientListViewController!
    var mockViewModel: MockIngredientsListViewModel!
    var mockCoordinator: MockIngredientListCoordinator!
    var tableView: UITableView!
    var addButtonTappedRelay: PublishRelay<Void>!
    var modelDeletedRelay: PublishRelay<RecipeIngredient>!
    var modelSelectedRelay: PublishRelay<RecipeIngredient>!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockViewModel = MockIngredientsListViewModel()
        mockCoordinator = MockIngredientListCoordinator()
        tableView = UITableView()
        addButtonTappedRelay = PublishRelay<Void>()
        modelDeletedRelay = PublishRelay<RecipeIngredient>()
        modelSelectedRelay = PublishRelay<RecipeIngredient>()
        disposeBag = DisposeBag()

        viewController = IngredientListViewController(
            tableView: tableView,
            viewModel: mockViewModel,
            coordinator: mockCoordinator,
            addButtonTappedRelay: addButtonTappedRelay,
            modelDeletedRelay: modelDeletedRelay,
            modelSelectedRelay: modelSelectedRelay
        )
    }

    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        mockCoordinator = nil
        tableView = nil
        addButtonTappedRelay = nil
        modelDeletedRelay = nil
        modelSelectedRelay = nil
        disposeBag = nil
        super.tearDown()
    }

    func testFetchIngredientsOnViewDidLoad() {
        let fetchExpectation = expectation(description: "Fetch ingredients should be called")
        
        mockViewModel.fetchCompletion = {
            fetchExpectation.fulfill()
        }
        
        triggerViewDidLoad()
        
        waitForExpectations(timeout: 1)
    }

    func testAddButtonTapped() {
        let addButtonExpectation = expectation(description: "Add button should trigger coordinator")
        
        mockCoordinator.presentIngredientFormCompletion = { ingredient, completion in
            XCTAssertNil(ingredient)
            addButtonExpectation.fulfill()
            completion()
        }
        
        triggerViewDidLoad()
        
        addButtonTappedRelay.accept(())
        
        waitForExpectations(timeout: 1)
    }

    func testModelDeleted() {
        let ingredient = RecipeIngredient()
        let deleteExpectation = expectation(description: "Delete should trigger viewModel.delete")
        
        mockViewModel.deleteCompletion = { deletedIngredient in
            XCTAssertEqual(deletedIngredient, ingredient)
            deleteExpectation.fulfill()
        }
        
        triggerViewDidLoad()
        
        modelDeletedRelay.accept(ingredient)
        
        waitForExpectations(timeout: 1)
    }

    func testModelSelected() {
        let ingredient = RecipeIngredient()
        let selectExpectation = expectation(description: "Selecting an ingredient should trigger coordinator")
        
        mockCoordinator.presentIngredientFormCompletion = { selectedIngredient, completion in
            XCTAssertEqual(selectedIngredient, ingredient)
            selectExpectation.fulfill()
            completion()
        }
        
        triggerViewDidLoad()
        
        modelSelectedRelay.accept(ingredient)
        
        waitForExpectations(timeout: 1)
    }

    func testTableViewBinding() {
        let testIngredients = [RecipeIngredient(), RecipeIngredient()]
        mockViewModel.ingredients.accept(testIngredients)
        
        triggerViewDidLoad()
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), testIngredients.count)
    }
    
    private func triggerViewDidLoad() {
        _ = viewController.view
    }
}
