//
//  PackageListPresenter.swift
//  Tracel
//
//  Created by Maciej Sączewski on 2/19/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation

class PackageListPresenter: PresenterInterface {
    typealias RouterPresenter = PackageListRouterPresenterInterface
    
    typealias InteractorPresenter = PackageListInteractorPresenterInterface
    
    typealias ViewModel = PackageListViewModel
    
    var router: RouterPresenter!
    var interactor: InteractorPresenter!
    var viewModel: ViewModel!
    
}

extension PackageListPresenter: PackageListPresenterViewInterface {
    
}

extension PackageListPresenter: PackageListPresenterRouterInterface {
    
}

extension PackageListPresenter: PackageListPresenterInteractorInterface {
    
}
