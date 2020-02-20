//
//  PackageListInteractor.swift
//  Tracel
//
//  Created by Maciej Sączewski on 2/19/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation

class PackageListInteractor: InteractorInterface {
    
    typealias PresenterInteractor = PackageListPresenterInteractorInterface
    
    var presenter: PresenterInteractor!
    
}

extension PackageListInteractor: PackageListInteractorPresenterInterface {
    
}
