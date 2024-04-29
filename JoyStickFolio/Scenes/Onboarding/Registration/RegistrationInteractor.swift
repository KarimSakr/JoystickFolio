//
//  RegistrationInteractor.swift
//  JoyStickFolio
//
//  Created by Karim Sakr on 14/03/2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import RxSwift

protocol RegistrationBusinessLogic {
    
    var data: [String : String] { get set }
    var progressValue: Double { get set }
    var index: Int { get set }
    
    var processes:[RegistrationModels.Request.RegistrationProcess] { get set }
    
    func registerUser() async -> Single<Void>
    
    func didEnterFullNameSuccessfully(fullName: String) -> Bool
    
    func didEnterEmailSuccessfully(email: String) -> Bool
    
    func didEnterUsernameSuccessfully(username: String) async -> Bool
    
    func didEnterPasswordSuccessfully(password: String, repeatPassword: String) async -> Bool
    
    func nextEntry()
    
}

protocol RegistrationDataStore {
    
}

class RegistrationInteractor: RegistrationBusinessLogic, RegistrationDataStore {
  var presenter: RegistrationPresentationLogic?

    //MARK: - Managers
    private let authenticationManager = AuthenticationManager()
    private let databaseManager = DatabaseManager()
    
    //MARK: - Auth Validator
    private let validator = AuthValidator()
    private let animator = TextAnimator()
    
    //MARK: - User Data
    var data: [String : String] = [:]
    var progressValue: Double = 0.0
    var index : Int = 0
    
    var processes:[RegistrationModels.Request.RegistrationProcess] = [
        .init(title: "Well hello there! \nGot a name?", placeholder: "Full Name...", buttonTitle: "Next", process: .enterFullName),
        .init(title: "Nice to meet you! \nHow can we contact you?", placeholder: "Email...", buttonTitle: "Next", process: .enterEmail),
        .init(title: "How about a unique nickname?\nLike everybody else...", placeholder: "Username...", buttonTitle: "Next", process: .enterUsername),
        .init(title: "How about some privacy? \n No peeking... \nI promise :)", placeholder: "Confirm Password...", buttonTitle: "Submit", process: .enterPassword),
        .init(title: "Creating player...", placeholder: "", buttonTitle: "", process: .loading),
    ]
    
    private var bag = DisposeBag()
    
    func registerUser() async -> Single<Void> {
        let newUser = RegistrationModels.Request.CreatedUserProfile(email   : data[Constants.Key.Auth.email]!,
                                                                    fullName: data[Constants.Key.Auth.fullName]!,
                                                                    username: data[Constants.Key.Auth.username]!)
        let password = data[Constants.Key.Auth.password]!
        
        return await authenticationManager.registerUser(newUser: newUser, password: password)
    }
    
    func didEnterFullNameSuccessfully(fullName: String) -> Bool {
        guard let presenter = presenter else { return false }
        guard validator.isFullNameValid(textField: fullName) else {
            presenter.showError(with: "Invalid name")
            return false
        }
        data[Constants.Key.Auth.fullName] = fullName
        presenter.fullNameEntered()
        return true
    }
    
    func didEnterEmailSuccessfully(email: String) -> Bool {
        guard let presenter = presenter else { return false }
        guard validator.isEmailValid(textField: email) else {
            presenter.showError(with: "Invalid email")
            return false
        }
        data[Constants.Key.Auth.email] = email
        presenter.emailEntered()
        return true
    }
    
    func didEnterUsernameSuccessfully(username: String) async -> Bool{
        guard let presenter = presenter else { return false }
        guard validator.isUsernameValid(textField: username) else {
            presenter.showError(with: "Invalid username, should be between 4 and 20, no special characters, and no spaces")
            return false
        }
        
        presenter.addLoadingIndicator()
        
        guard await isUsernameAvailable(username: username) else {
            presenter.showError(with: "Username already taken")
            presenter.removeLoadingIndicator()
            return false
        }
        data[Constants.Key.Auth.username] = username
        presenter.usernameEntered()
        return true
    }
    
    func didEnterPasswordSuccessfully(password: String, repeatPassword: String) async -> Bool {
        guard let presenter = presenter else { return false }
        guard validator.isPasswordValid(textfield: password, repeatTextField: repeatPassword) else {
            presenter.showError(with: "Passwords should match and have a minimum length of 6 characters")
            return false
        }
        data[Constants.Key.Auth.password] = password
        presenter.passwordEntered()
        nextEntry()
        await registerUser()
            .subscribe {  _ in
                AnalyticsManager.logEvent(event: .signup)
                presenter.dismissRegistrationScreen()
                
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                resetRegistration()
                presenter.showError(with: error.localizedDescription)
            }
            .disposed(by: bag)
        
        return false
    }
    
    private func resetRegistration() {
        guard let presenter = presenter else { return }
        
        data = [:]
        progressValue = 0
        index = 0
        
        presenter.resetRegistration(mainTextFieldPlaceholder: processes[index].placeholder, buttonSetTitle: processes[index].buttonTitle, titleLableText: processes[index].title)
    }
    
    private func isUsernameAvailable(username: String) async -> Bool {
        return await authenticationManager.isUsernameAvailable(username: username)
    }
    
    func nextEntry() {
        guard let presenter = presenter else { return }
        index += 1
        progressValue += 1.0 / Double(processes.count - 1)
        
        presenter.nextEntry(mainTextFieldPlaceholder: processes[index].placeholder, buttonSetTitle: processes[index].buttonTitle, progressValue: Float(progressValue))
        
        animator.animateTitle(text: processes[index].title, timeInterval: 0.01) { letter in
            presenter.appendLetter(letter: letter)
        }
    }
}
