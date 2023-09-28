//
//  FirebaseManager.swift
//  FireStoreProject
//
//  Created by Abhishek Pandey on 13/09/23.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage
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

    /// Register the new user in user collection
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
    public func fetchUsers(fromCollection collectionName: String, completion: @escaping ([QueryDocumentSnapshot]?) -> Void) {
        database.collection(collectionName).addSnapshotListener { querySnapshot, error in
            if let error {
                debugPrint("Error fetching users: \(error.localizedDescription)")
                completion(nil)
                return
            }
            completion(querySnapshot?.documents)
        }
    }

    // MARK: - fetchChatList

    /// Fetch the all member message who had done chat with user
    public func fetchChatList(with collection: CollectionType, completion: @escaping ([QueryDocumentSnapshot]?) -> Void) {
        database.collection(collection.rawValue).whereField(kUsers, arrayContains: getCurrentUser(with: .UID)).addSnapshotListener { querySnapshot, error in
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

    /// Initiate the chat with single user or in group
    public func createGroup(with message: [String: Any], collection type: CollectionType, completion: @escaping (_ isSuccess: Bool, String) -> Void) {
        let usersCollection = database.collection(type.rawValue)
        let randomDocumentID = usersCollection.document().documentID
        var messageWithID = message
        messageWithID["id"] = randomDocumentID
        usersCollection.document(randomDocumentID).setData(messageWithID) { err in
            if err == nil {
                completion(true, randomDocumentID)
            } else {
                completion(false, randomDocumentID)
            }
        }
    }

    // MARK: - GetUserDetail

    /// Get the any user detail with uid parameter
    public func getUserDetail(forUID uid: String, type: FieldType, completion: @escaping (String?, String?) -> Void) {
        let usersCollection = database.collection(kUsers)
        usersCollection.whereField(type.rawValue, isEqualTo: uid).getDocuments { querySnapshot, error in
            if let error {
                debugPrint("Error getting user document: \(error.localizedDescription)")
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
    public func getCurrentUser(with field: FieldType) -> String {
        if let currentUser = Auth.auth().currentUser {
            if field == .email {
                return currentUser.email ?? ""
            } else if field == .UID {
                return currentUser.uid
            } else {
                return currentUser.displayName ?? ""
            }
        }
        return ""
    }

    // MARK: - Send Message

    /// send messge to the receiver by sender
    public func sendMessage(with documentID: String, message: [String: Any], type: CollectionType, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let parentDocumentReference = database.collection(kMessages).document(documentID)
        let messageCollection = parentDocumentReference.collection(type.rawValue)
        let randomDocumentID = messageCollection.document().documentID
        var messageWithID = message
        messageWithID["id"] = randomDocumentID
        messageCollection.addDocument(data: messageWithID) { err in
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

    /// Get the individual the user all messages
    public func getIndividualChat(user: String, completion: @escaping ([QueryDocumentSnapshot]?) -> Void) {
        database.collection(kMessages)
            .whereField(kUsers, arrayContains: user)
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

    // MARK: - Last Message Update

    /// Save the last message send by the sender in messages collection with document id
    public func lastMessageUpdate(with collection: CollectionType, data: [String: Any], documentID: String, message _: String, completion: @escaping (Bool?) -> Void) {
        database.collection(collection.rawValue).document(documentID).updateData(data) { error in
            if let error {
                debugPrint("Error updating document: \(error)")
                completion(false)
            } else {
                debugPrint("Document successfully updated.")
                completion(true)
            }
        }
    }

    // MARK: - uploadMediaToFirebaseStorage

    public func uploadMediaToFirebaseStorage(data: Data, contentType: ContentType, completion: @escaping (String?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let unixTimestampMilliseconds = Date().timeIntervalSince1970 * 1000
        let mediaRef = storageRef.child("\(contentType.rawValue)/\(unixTimestampMilliseconds).jpeg")
        let metadata = StorageMetadata()
        metadata.contentType = contentType == .image ? "image/jpeg" : "video/mp4"
        mediaRef.putData(data, metadata: metadata) { _, error in
            if let error {
                debugPrint("Error uploading media: \(error)")
                completion(nil)
            } else {
                mediaRef.downloadURL { url, error in
                    if let downloadURL = url {
                        let urlString = downloadURL.absoluteString
                        completion(urlString)
                    } else {
                        debugPrint("Error getting download URL: \(String(describing: error))")
                        completion(nil)
                    }
                }
            }
        }
    }
}
