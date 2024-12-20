//
//  MockIngredientsListViewModel.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 20/12/24.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa
@testable import RxSwift_Recipes

class MockIngredientsListViewModel: IngredientsListViewModelProtocol {
    
    var ingredients = BehaviorRelay<[RecipeIngredient]>(value: [])
    
    var fetchCompletion: (() -> Void)?
    var deleteCompletion: ((_ ingredient: RecipeIngredient) -> Void)?
    
    func fetch() {
        fetchCompletion?()
    }
    
    func delete(_ ingredient: RecipeIngredient) {
        deleteCompletion?(ingredient)
    }
}
