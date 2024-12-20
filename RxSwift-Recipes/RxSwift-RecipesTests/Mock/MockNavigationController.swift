//
//  MockNavigationController.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 20/12/24.
//

import UIKit

class MockNavigationController: UINavigationController {
    
    var pushViewControllerCompletion: ((_ viewController: UIViewController, _ animated: Bool) -> Void)?
    var presentViewControllerCompletion: ((_ viewControllerToPresent: UIViewController, _ animated: Bool, _ completion: (() -> Void)?) -> Void)?
    var dismissCompletion: ((_ animated: Bool, _ completion: (() -> Void)?) -> Void)?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerCompletion?(viewController, animated)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        presentViewControllerCompletion?(viewControllerToPresent, animated, completion)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissCompletion?(flag, completion)
    }
}
