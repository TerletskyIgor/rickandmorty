//
//  CartoonCharactersRouter.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

protocol CartoonCharactersRoutingLogic: AnyObject {
    // func showDetail()
}

final class CartoonCharactersRouter {
    weak var viewController: CartoonCharactersViewController?
}

extension CartoonCharactersRouter : CartoonCharactersRoutingLogic {
    
}
