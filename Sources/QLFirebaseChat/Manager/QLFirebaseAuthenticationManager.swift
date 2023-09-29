//
//  QLFirebaseAuthenticationManager.swift
//
//
//  Created by Abhishek Pandey on 15/09/23.
//

import FirebaseAuth
import Foundation

public class QLFirebaseAuthenticationManager {
    // MARK: - Properties

    public static let shared = QLFirebaseAuthenticationManager()

    // MARK: - Initialization

    public init() {}

    // MARK: - User Registration

    /// Registers a new user with the provided email and password.
    ///
    /// - Parameters:
    ///   - email: The email address for registration.
    ///   - password: The password for registration.
    ///   - completion: A closure that gets called after the registration attempt.
    public func registerChatUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user {
                completion(.success(user))
            } else if let error {
                completion(.failure(error))
            }
        }
    }

    // MARK: - User Login

    /// Logs in an existing user with the provided email and password.
    ///
    /// - Parameters:
    ///   - email: The email address for login.
    ///   - password: The password for login.
    ///   - completion: A closure that gets called after the login attempt.
    public func loginChatUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user {
                completion(.success(user))
            } else if let error {
                completion(.failure(error))
            }
        }
    }

    // MARK: - User Logout

    /// Logs out the currently logged-in user.
    ///
    /// - Parameter completion: A closure that gets called after the logout attempt.
    public func logoutChatUser(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
