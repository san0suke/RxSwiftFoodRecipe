//
//  UITableViewDiffableDataSource.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 16/12/24.
//

import UIKit

extension UITableViewDiffableDataSource {
    
    func delete(item: ItemIdentifierType) {
        var snapshot = self.snapshot()
        snapshot.deleteItems([item])
        apply(snapshot, animatingDifferences: true)
    }
}
