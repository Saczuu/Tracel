//
//  PackageListRouter.swift
//  Tracel
//
//  Created by Maciej Sączewski on 2/19/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation

class PackageListRouter: RouterInterface {
    
    typealias PresenterRouter = PackageListPresenterRouterInterface
    
    var presenter: PresenterRouter!
    
}

extension PackageListRouter: PackageListRouterPresenterInterface {
    
}
