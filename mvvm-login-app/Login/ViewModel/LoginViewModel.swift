//
//  LoginViewModel.swift
//  mvvm-login-app
//
//  Created by KARLOS AGUIRRE on 5/9/23.
//

import Foundation
import Combine

final class LoginViewModel {
    
    @Published var email = ""
    @Published var password = ""
    @Published var loginButtonIsEnabled = false
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var userModel:User?
    
    private var cancellables = Set<AnyCancellable>()
    
    let apiClient: APIClientType
    
    init(apiClient: APIClientType = APIClient()) {
        self.apiClient = apiClient
        
        formValidation()
    }
    
    private func formValidation() {
        Publishers.CombineLatest($email, $password)
            .filter { email, password in
                return email.count > 5 && password.count > 5
            }
            .sink { [weak self] value in
                self?.loginButtonIsEnabled = true
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func userLogin(with email: String, password: String) {
        errorMessage = ""
        isLoading = true
        Task {
            do {
                userModel = try await apiClient.login(with: email, password: password)
            } catch let error as BackendErrors {
                self.errorMessage = error.rawValue
            }
            isLoading = false
        }
    }
}
