//
//  FirebaseManager.swift
//  FireStoreProject
//
//  Created by Abhishek Pandey on 13/09/23.
//

import Firebase
import FirebaseFirestore
import Foundation

public class FirebaseManager {
    // MARK: - Properties

    public static let shared = FirebaseManager()
    var database: Firestore

    // MARK: Intialization

    init() {
        database = Firestore.firestore()
    }

    // MARK: Create New User

    /// Register the new user in user collection after the authentication
    public func addNewUser(with user: [String: Any], id: String, collection type: CollectionType, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let usersCollection = database.collection(type.rawValue)
        let userDocument = usersCollection.document(id)
        userDocument.setData(user) { err in
            if err == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    // MARK: fetchUsers

    /// Fetch the user list from the user collection
    public func fetchUsers(with collectionName: String, completion: @escaping ([QueryDocumentSnapshot]?) -> Void) {
        database.collection(collectionName).addSnapshotListener { querySnapshot, error in
            if let error {
                debugPrint("Error fetching users: \(error.localizedDescription)")
                return
            }

            if let documents = querySnapshot?.documents {
                completion(documents)
            }
        }
    }

    // MARK: - fetchChatList

    /// Fetch the all member message who is already done the chat
    public func fetchChatList(with collectionName: String, completion: @escaping ([QueryDocumentSnapshot]?) -> Void) {
        database.collection(collectionName).whereField(kUsers, arrayContains: getCurrentUser()).addSnapshotListener { querySnapshot, error in
            if let error {
                debugPrint("Error fetching users: \(error.localizedDescription)")
                completion(nil)
            }

            if let documents = querySnapshot?.documents {
                completion(documents)
            }
        }
    }

    // MARK: createGroup

    /// Initiate the chat in single user or group
    public func createGroup(with message: [String: Any], id: String, collection type: CollectionType, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let usersCollection = database.collection(type.rawValue)
        let userDocument = usersCollection.document(id)
        userDocument.setData(message) { err in
            if err == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    // MARK: - GetUserName

    /// Get the user detail by UID
    public func getUserName(forUID uid: String, type: FieldType, completion: @escaping (String?, String?) -> Void) {
        let usersCollection = database.collection(kUsers)
        usersCollection.whereField(type.rawValue, isEqualTo: uid).getDocuments { querySnapshot, error in
            if let error {
                print("Error getting user document: \(error.localizedDescription)")
                completion(nil, nil)
            } else {
                if let document = querySnapshot?.documents.first {
                    if let userName = document.data()[kName] as? String, let uid = document.data()[kUID] as? String {
                        completion(userName, uid)
                    } else {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, nil)
                }
            }
        }
    }

    // MARK: - getCurrentUser

    /// Get current user email ID
    public func getCurrentUser() -> String {
        if let email = Auth.auth().currentUser?.uid {
            return email
        }
        return ""
    }

    // MARK: - Send Message

    /// send messge to the receiver by sender
    public func sendMessage(with documentID: String, message: [String: Any], type: CollectionType, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let parentDocumentReference = database.collection(kMessages).document(documentID)
        parentDocumentReference.collection(type.rawValue).addDocument(data: message) { err in
            if err == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    // MARK: - FetchMessages

    /// Fetch messages from the receivers by current user
    public func fetchMessages(with documentID: String, completion: @escaping ([QueryDocumentSnapshot]?) -> Void) {
        let parentDocumentReference = database.collection(kMessages).document(documentID)
        parentDocumentReference.collection(kMessage).order(by: kSendTime, descending: false).addSnapshotListener { querySnapshot, error in
            if let error {
                debugPrint("Error fetching documents: \(error.localizedDescription)")
            } else {
                if let documents = querySnapshot?.documents {
                    completion(documents)
                }
            }
        }
    }

    // MARK: -  GetIndividualChat

    public func getIndividualChat(users: [String], completion: @escaping ([QueryDocumentSnapshot]?) -> Void) {
        database.collection(kMessages)
            .whereField(kUsers, arrayContains: users.last!)
            .getDocuments { querySnapshot, error in
                if let error {
                    debugPrint("Error fetching users: \(error.localizedDescription)")
                    completion(nil)
                }

                if let documents = querySnapshot?.documents {
                    completion(documents)
                }
            }
    }
}
