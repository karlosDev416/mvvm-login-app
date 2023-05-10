//
//  APIClient.swift
//  mvvm-login-app
//
//  Created by KARLOS AGUIRRE on 5/9/23.
//

import Foundation

enum BackendErrors: String, Error {
    case invalidEmail = "Comprueba el email"
    case invalidPassword = "Comprueba el password"
}

protocol APIClientType {
    func login(with email:String, password:String) async throws -> User
}

final class APIClient: APIClientType {
    func login(with email:String, password:String) async throws -> User {
        try await Task.sleep(nanoseconds: NSEC_PER_SEC * 2)
        return try simulateBackednLogin(email: email, password: password)
    }
}

func simulateBackednLogin(email:String, password:String) throws -> User {
    guard email == "email@gmail.com" else {
        print("El email no es email@gmail.com")
        throw BackendErrors.invalidEmail
    }
    guard password == "123456" else {
        print("El password no es 123456")
        throw BackendErrors.invalidPassword
    }
    return User(name: "userName",
                token: "token_123456",
                sessionStart: .now)
}
