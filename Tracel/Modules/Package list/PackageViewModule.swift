//
//  PackageViewModule.swift
//  Tracel
//
//  Created by Maciej Sączewski on 2/19/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation
import SwiftUI

//MARK: - Router
protocol PackageListRouterPresenterInterface: RouterPresenterInterface {
}

//MARK: - Interactor
protocol PackageListInteractorPresenterInterface: InteractorPresenterInterface {
}

//MARK: - Presenter
protocol PackageListPresenterRouterInterface: PresenterRouterInterface {

}

protocol PackageListPresenterInteractorInterface: PresenterInteractorInterface {
    
}

protocol PackageListPresenterViewInterface: PresenterViewInterface {
    
}

//MARK: - Module
final class PackageListModule: ModuleInterface {
    typealias View = PackageListView
    
    typealias Presenter = PackageListPresenter
    
    typealias Router = PackageListRouter
    
    typealias Interactor = PackageListInteractor
    
    typealias ViewModel = PackageListViewModel
    
    @Environment(\.managedObjectContext) var moc
    
    func build() -> View {
        let presenter = Presenter()
        let interactor = Interactor().environment(\.managedObjectContext, self.moc)
        let router = Router()
        let viewModel = ViewModel()
        
        self.assemble(presenter: presenter, router: router, interactor: interactor, viewModel: viewModel)
        let view = PackageListView(presenter: presenter, viewModel: viewModel)
        view.environment(\.managedObjectContext, self.moc)
        return view as! PackageListView
    }

}
