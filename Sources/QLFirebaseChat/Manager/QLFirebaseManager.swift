//
//  QLFirebaseManager.swift
//  QLFirebaseChat
//
//  Created by Abhishek Pandey on 13/09/23.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage
import Foundation

public class QLFirebaseManager {
    // MARK: - Properties

    public static let shared = QLFirebaseManager()
    var database: Firestore

    // MARK: Intialization

    init() {
        database = Firestore.firestore()
    }

    // MARK: - User Management

    /// Registers a new user in the specified collection.
    ///
    /// - Parameters:
    ///   - user: User data to be added.
    ///   - id: Unique identifier for the user.
    ///   - type: Collection type where the user will be added.
    ///   - completion: Closure called after the operation is completed.
    public func addChatUser(with data: [String: Any], id: String, collection type: CollectionType, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let usersCollection = database.collection(type.rawValue)
        let userDocument = usersCollection.document(id)
        userDocument.setData(data) { err in
            if err == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    /// Fetches a list of users from the specified collection.
    ///
    /// - Parameters:
    ///   - collectionName: Name of the collection to fetch users from.
    ///   - completion: Closure called with the fetched documents.
    public func fetchChatUsers(fromCollection collectionName: String, completion: @escaping ([QueryDocumentSnapshot]?) -> Void) {
        database.collection(collectionName).addSnapshotListener { querySnapshot, error in
            if let error {
                debugLog(logType: .error, text: "Error fetching users: \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(querySnapshot?.documents)
            }
        }
    }

    /// Retrieves user details for a specific UID from the user collection.
    ///
    /// - Parameters:
    ///   - uid: The UID of the user to retrieve details for.
    ///   - type: The type of field (e.g., UID) to match against in the user collection.
    ///   - completion: Closure called after retrieving user details, providing user's name and UID, or nil if not found.
    public func getChatUserDetail(with uid: String, type: FieldType, completion: @escaping (String?, String?) -> Void) {
        let usersCollection = database.collection(kUsers)
        usersCollection.whereField(type.rawValue, isEqualTo: uid).getDocuments { querySnapshot, error in
            if let error {
                debugLog(logType: .error, text: "Error getting user document: \(error.localizedDescription)")
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

    /// Retrieves the login user's information based on the specified field type.
    ///
    /// - Parameters:
    ///   - field: The field type (e.g., email, UID) for which to retrieve the user information.
    /// - Returns: The current user's information based on the specified field type.
    public func getLoggedInUserDetails(with field: FieldType) -> String {
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

    // MARK: - Chat Management

    /// Fetches the chat list for the current user.
    ///
    /// - Parameters:
    ///   - collection: Collection type where chat data is stored.
    ///   - completion: Closure called with the fetched chat documents.
    public func fetchChatList(with collection: CollectionType, completion: @escaping ([QueryDocumentSnapshot]?) -> Void) {
        let currentUserUID = getLoggedInUserDetails(with: .UID)
        database.collection(collection.rawValue).whereField(kUsers, arrayContains: currentUserUID).addSnapshotListener { querySnapshot, error in
            if let error {
                debugLog(logType: .error, text: "Error fetching chats: \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(querySnapshot?.documents)
            }
        }
    }

    /// Initiates a chat with single or multiple users.
    ///
    /// - Parameters:
    ///   - message: Message data to be sent.
    ///   - type: Collection type where the chat message will be stored.
    ///   - completion: Closure called after the chat creation operation is completed.
    public func createChat(with message: [String: Any], collection type: CollectionType, completion: @escaping (_ isSuccess: Bool, _ documentID: String) -> Void) {
        let chatCollection = database.collection(type.rawValue)
        let randomDocumentID = chatCollection.document().documentID
        var messageWithID = message
        messageWithID["id"] = randomDocumentID
        chatCollection.document(randomDocumentID).setData(messageWithID) { error in
            if let error {
                debugLog(logType: .error, text: "Error creating chat: \(error.localizedDescription)")
                completion(false, randomDocumentID)
            } else {
                completion(true, randomDocumentID)
            }
        }
    }

    /// Sends a message to the receiver from the sender.
    ///
    /// - Parameters:
    ///   - documentID: ID of the document representing the chat or group conversation.
    ///   - message: The message content along with metadata to be sent.
    ///   - type: The type of collection (e.g., individual chat, group chat) to send the message to.
    ///   - completion: Closure called after sending the message, indicating success or failure.
    public func sendChatMessage(with documentID: String, message: [String: Any], type: CollectionType, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let parentDocumentReference = database.collection(kMessages).document(documentID)
        let messageCollection = parentDocumentReference.collection(type.rawValue)
        let randomDocumentID = messageCollection.document().documentID
        var messageWithID = message
        messageWithID["id"] = randomDocumentID
        messageCollection.document(randomDocumentID).setData(messageWithID) { err in
            if let error = err {
                debugLog(logType: .error, text: "Error sending message: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    /// Fetches messages for a specific chat.
    ///
    /// - Parameters:
    ///   - documentID: ID of the chat document.
    ///   - completion: Closure called with the fetched message documents.
    public func fetchChatMessages(forChat documentID: String, completion: @escaping ([QueryDocumentSnapshot]?) -> Void) {
        let chatDocumentReference = database.collection(kMessages).document(documentID)
        chatDocumentReference.collection(kMessage).order(by: kSendTime, descending: false).addSnapshotListener { querySnapshot, error in
            if let error {
                debugLog(logType: .error, text: "Error fetching chat messages: \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(querySnapshot?.documents)
            }
        }
    }

    /// Fetches all messages for an individual chat.
    ///
    /// - Parameters:
    ///   - user: User for whom the chat messages will be fetched.
    ///   - completion: Closure called with the fetched message documents.
    public func fetchMessagesForIndividualChat(with user: String, completion: @escaping ([QueryDocumentSnapshot]?) -> Void) {
        database.collection(kMessages).whereField(kUsers, arrayContains: user).getDocuments { querySnapshot, error in
            if let error {
                debugLog(logType: .error, text: "Error fetching individual chat: \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(querySnapshot?.documents)
            }
        }
    }

    /// Updates the last message sent by the sender in the specified collection.
    ///
    /// - Parameters:
    ///   - collection: Collection type where the message data is stored.
    ///   - data: Data to be updated in the document.
    ///   - documentID: ID of the document to be updated.
    ///   - message: The last message to be updated.
    ///   - completion: Closure called after the update operation is completed.
    public func updateLastChatMessage(with collection: CollectionType, data: [String: Any], documentID: String, message: String, completion: @escaping (Bool?) -> Void) {
        database.collection(collection.rawValue).document(documentID).updateData(data) { error in
            if let error {
                debugLog(logType: .error, text: "Error updating document: \(error)")
                completion(false)
            } else {
                debugLog(logType: .success, text: "Last message successfully updated to: \(message)")
                completion(true)
            }
        }
    }

    // MARK: - Storage Management

    /// Uploads media data to Firebase Storage.
    ///
    /// - Parameters:
    ///   - data: The media data to be uploaded.
    ///   - contentType: Type of media content (image or video).
    ///   - completion: Closure called after the upload is completed with the download URL of the uploaded media.
    public func uploadChatMedia(data: Data, contentType: ContentType, completion: @escaping (String?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let unixTimestampMilliseconds = Date().timeIntervalSince1970 * 1000
        let mediaRef = storageRef.child("\(contentType.rawValue)/\(unixTimestampMilliseconds).jpeg")
        let metadata = StorageMetadata()
        metadata.contentType = contentType == .image ? "image/jpeg" : "video/mp4"
        mediaRef.putData(data, metadata: metadata) { _, error in
            if let error {
                debugLog(logType: .error, text: "Error uploading media: \(error)")
                completion(nil)
            } else {
                mediaRef.downloadURL { url, error in
                    if let downloadURL = url {
                        let urlString = downloadURL.absoluteString
                        completion(urlString)
                    } else {
                        debugLog(logType: .error, text: "Error getting download URL: \(String(describing: error))")
                        completion(nil)
                    }
                }
            }
        }
    }
}
