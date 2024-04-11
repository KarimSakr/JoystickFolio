//
//  LoginInteractor.swift
//  JoyStickFolio
//
//  Created by Karim Sakr on 11/03/2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import FirebaseAuth
import RxSwift
import AppTrackingTransparency

protocol LoginBusinessLogic {
    
    func checkifUserIsSignedIn() -> Bool
    
    func login(usernameEmail: String, password: String) async -> Single<AuthDataResult>
    
    func requestIDFA()
    
}

protocol LoginDataStore {
    
}

class LoginInteractor: LoginBusinessLogic, LoginDataStore {
    var presenter: LoginPresentationLogic?
    
    //MARK: - Managers
    private let authManager = AuthenticationManager()
        
    func login(usernameEmail: String, password: String) async -> Single<AuthDataResult> {
        
        return await authManager.signIn(usernameEmail: usernameEmail, password: password)
        
    }
    
    func checkifUserIsSignedIn() -> Bool {
        
        if Auth.auth().currentUser == nil {
            return false
        }
        return true
    }
    
    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized, .denied, .notDetermined, .restricted: break
                @unknown default: break
                }
            }
        }
    }
}
