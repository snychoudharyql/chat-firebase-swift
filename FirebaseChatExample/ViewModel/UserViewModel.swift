//
//  UserViewModel.swift
//  FireStoreProject
//
//  Created by Abhishek Pandey on 13/09/23.
//

import Foundation
import QLFirebaseChat
import Firebase
import FirebaseFirestore

class UserViewModel: ObservableObject {
    
    //MARK: - Properties
    @Published var userName = ""
    @Published var userEmailID = ""
    @Published var userPassword = ""
    @Published var isUserSuccessfulLogin = false
    @Published var isChatInitiated = false
    @Published var isLoading = false
    @Published var errorMessage = ErrorMesaage()

    // MARK: User Login
    func loginUser(email: String, password: String) {
        if !email.isEmpty, !password.isEmpty {
            isLoading = true
            FirebaseAuthManager.shared.loginUser(email: email, password: password) { result in
                self.isLoading = false
                switch result {
                case .success:
                    self.isUserSuccessfulLogin = true
                    UserDefaults.standard.set(true, forKey: userStatus)
                case .failure(let failure):
                    self.errorMessage.message = failure.localizedDescription
                    self.errorMessage.isError = true
                }
            }
        }
    }
    
    //MARK: - Register User
    func registerUser(email: String, password: String) {
        if !email.isEmpty, !password.isEmpty, !userName.isEmpty{
            isLoading = true
            FirebaseAuthManager.shared.registerUser(email: email, password: password) { result in
                self.isLoading  = false
                switch result {
                case .success(let user):
                    self.isUserSuccessfulLogin = true
                    UserDefaults.standard.set(true, forKey: userStatus)
                    self.createNewUser(with: user.uid)
                    
                case .failure(let failure):
                    self.errorMessage.message = failure.localizedDescription
                    self.errorMessage.isError = true
                    debugPrint("Register Failure:", failure)
                }
            }
        }
    }
    
    //MARK: - Create New User
    func createNewUser(with userId: String) {
        var user  = [String: Any]()
        user["name"] = userName
        user["email"] = userEmailID.lowercased()
        user["uid"]  = userId
        FirebaseManager.shared.addNewUser(with: user, id: userId, collection: .users) { isSuccess in
            self.isUserSuccessfulLogin = isSuccess
        }
    }
    

}
