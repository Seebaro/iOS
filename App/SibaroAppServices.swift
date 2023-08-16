//
//  SibaroAppServices.swift
//  Sibaro
//
//  Created by Ebrahim Tahernejad on 5/24/1402 AP.
//

import Foundation
#if os(iOS)
import UIKit
#else
import Cocoa
#endif

// MARK: - Services
extension Container {
    var i18n: Factory<I18nServicable> {
        Factory(self) { I18nService() }
    }
    
    var storage: Factory<StorageServicable> {
        Factory(self) { StorageService() }
    }
    
    var applications: Factory<ApplicationServicable> {
        Factory(self) { ApplicationService() }
    }
}


// MARK: - Repositories
extension Container {
    var authRepository: Factory<AuthRepositoryType> {
        Factory(self) { AuthRepository() }
    }
    
    var productRepository: Factory<ProductsRepositoryType> {
        Factory(self) { ProductsRepository() }
    }
}

// MARK: - Functions
extension Container {
    var openURL: Factory<(_ url: URL) -> Bool> {
        Factory(self) {
            #if os(iOS)
            UIApplication.shared.openURL
            #else
            NSWorkspace.shared.open
            #endif
        }
    }
}