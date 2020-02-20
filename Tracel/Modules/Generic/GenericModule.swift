//
//  GenericModule.swift
//  Gadator
//
//  Created by Maciej Sączewski on 12/11/19.
//  Copyright © 2019 SCM. All rights reserved.
//

import Foundation

// MARK: - VIPER
public protocol RouterInterface: RouterPresenterInterface {
    associatedtype PresenterRouter

    var presenter: PresenterRouter! { get set }
}

public protocol InteractorInterface: InteractorPresenterInterface {
    associatedtype PresenterInteractor
    
    var presenter: PresenterInteractor! { get set }
}

public protocol PresenterInterface: PresenterRouterInterface & PresenterInteractorInterface & PresenterViewInterface {
    associatedtype RouterPresenter
    associatedtype InteractorPresenter
    associatedtype ViewModel

    var router: RouterPresenter! { get set }
    var interactor: InteractorPresenter! { get set }
    var viewModel: ViewModel! { get set }
}

public protocol ViewInterface {
    associatedtype PresenterView
    
    var presenter: PresenterView! { get set }
}

public protocol EntityInterface {
    
}

// MARK: - "i/o" transitions
public protocol RouterPresenterInterface: class {
    
}

public protocol InteractorPresenterInterface: class {
    
}

public protocol PresenterRouterInterface: class {
    
}

public protocol PresenterInteractorInterface: class {
    
}

public protocol PresenterViewInterface: class {
    
}
// MARK: - module
public protocol ModuleInterface {

    associatedtype View where View: ViewInterface
    associatedtype Presenter where Presenter: PresenterInterface
    associatedtype Router where Router: RouterInterface
    associatedtype Interactor where Interactor: InteractorInterface
    associatedtype ViewModel where ViewModel: ObservableObject
    
    func assemble(presenter: Presenter, router: Router, interactor: Interactor, viewModel: ViewModel)
}

public extension ModuleInterface {

    func assemble(presenter: Presenter, router: Router, interactor: Interactor, viewModel: ViewModel) {

        presenter.interactor = (interactor as! Self.Presenter.InteractorPresenter)
        presenter.router = (router as! Self.Presenter.RouterPresenter)
        presenter.viewModel = (viewModel as! Self.Presenter.ViewModel)
        
        interactor.presenter = (presenter as! Self.Interactor.PresenterInteractor)
        
        router.presenter = (presenter as! Self.Router.PresenterRouter)
    }
}
