//
//  UIViewController.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 16/12/24.
//

import UIKit

extension UIViewController {
    
    func presentMediumModal(_ viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .pageSheet
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(navigationController, animated: true, completion: nil)
    }
    
//    func pushViewController(_ viewController: UIViewController) {
//        let navigationController = UINavigationController(rootViewController: viewController)
//        window?.rootViewController = navigationController
//        window?.makeKeyAndVisible()
//    }
}
