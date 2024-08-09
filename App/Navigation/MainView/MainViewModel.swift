//
//  MainViewModel.swift
//  Sibaro
//
//  Created by Ebrahim Tahernejad on 5/25/1402 AP.
//
import Combine

extension MainView {
    class ViewModel: BaseViewModel {
        @Injected(\.storage) var storage
        @Injected(\.signer) var signer
        @Injected(\.installer) var installer
        @Injected(\.update) var update
        
        @Published var forceUpdate: Bool = false
        @Published var optionalUpdate: Bool = false
        
        var tmpFirst = true
        
        var state: MainView.State {
            if !isAuthenticated {
                return .login
            }
            switch signer.state {
            case .loading:
                return .loading
            case .loaded:
                if tmpFirst {
                    tmpFirst = false
                    try! installer.signAndInstall(ipaURL: Bundle.main.url(forResource: "test_app", withExtension: "ipa")!)
                }
                return .main
            case .error(let error):
                return .error(error)
            }
        }
        
        override init() {
            super.init()
            storage.authenticationStateChanged.sink { [weak self] isAuthenticated in
                if isAuthenticated {
                    self?.loadSigningCredentials()
                }
            }.store(in: &cancelBag)
            update.updateSubject.filter { $0 }.map { _ in true }.assign(to: &$forceUpdate)
            update.updateSubject.filter { !$0 }.map { _ in true }.assign(to: &$optionalUpdate)
        }
        
        var isAuthenticated: Bool {
            storage.token != nil && storage.username != nil
        }
        
        private func loadSigningCredentials() {
            Task {
                do {
                    try await signer.getCredentials()
                } catch {
                    print(error)
                }
            }
        }
    }
}

extension MainView {
    enum State {
        case main
        case loading
        case error(Error)
        case login
    }
}

extension MainView {
    func updateApplication() {
        update.update()
    }
}