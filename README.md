# QLFirebaseChat

QLFirebaseChat is a Swift package that simplifies chat functionality using Firebase Firestore. This package provides an easy way to integrate real-time chat features into your Swift applications.

## Installation

You can install QLFirebaseChat using Swift Package Manager (SPM). Follow these steps to add it to your Xcode project:

 Add the library as a Swift package dependency.

- In Xcode, open your project.
- Go to "File" > "Swift Packages" > "Add Package Dependency..."
- Enter the following URL: `https://github.com/Quokka-Labs-LLP/chat-firebase-swift.git`
- Select the version or branch you` want to use.
- Click "Finish."
- Import package with `import QLFirebaseChat`

 ## Usage

 ### Initialize Firebase

To use Firebase services in your chat application, you need to initialize Firebase. Call the `initialize` method to configure Firebase. You should typically do this early in your app's lifecycle, such as in your app delegate's `application(_:didFinishLaunchingWithOptions:)` method.

This method configures Firebase with the settings specified in your project's Firebase configuration file.

Make sure you have added your Firebase configuration file (usually named GoogleService-Info.plist) to your Xcode project.

```swift
import QLChatFirebase

// Initialize Firebase in your app delegate
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Initialize Firebase for your chat functionality
    // Option 1: Using QLChatFirebase
    QLChatFirebase.initialize()

    // Option 2: Using Firebase directly
     FirebaseApp.initialize()
    return true
}
```
Once Firebase is initialized, you can use other Firebase services, such as Firestore and Authentication, in your chat application.

## Usage of QLFirebaseAuthenticationManager

 ### Register a New Chat User

To register a new chat user, use the `registerChatUser` method. Provide the user's email and password as parameters. Here's an example:

```swift
QLFirebaseAuthenticationManager.shared.registerUser(email: "user@example.com", password: "password") { result in
    switch result {
    case .success(let user):
        print("User registration successful. User ID: \(user.uid)")
    case .failure(let error):
        print("User registration failed with error: \(error.localizedDescription)")
    }
}
```
### Login an Existing Chat User

To log in an existing chat user, use the `loginChatUser` method. Provide the user's email and password as parameters. Here's an example:

```swift
 QLFirebaseAuthenticationManager.shared.loginChatUser(email: "user@example.com", password: "password") { result in
    switch result {
    case .success(let user):
        print("User login successful. User ID: \(user.uid)")
    case .failure(let error):
        print("User login failed with error: \(error.localizedDescription)")
    }
}
```
### Logout the Current Chat User

To log out the current chat user, use the `logoutChatUser` method. Here's an example:

```swift
QLFirebaseAuthenticationManager.shared.logoutChatUser { result in
    switch result {
    case .success:
        print("User logout successful.")
    case .failure(let error):
        print("User logout failed with error: \(error.localizedDescription)")
    }
}
```

## Usage of QLFirebaseManager

### Add New Chat User

To register a new chat user, use the `addChatUser` method. Provide the user's data, unique ID, and collection type. Example:

```swift
QLFirebaseManager.shared.addNewUser(with: userData, id: "uniqueUserID", collection: .users) { isSuccess in
    if isSuccess {
        print("User registration successful.")
    } else {
        print("User registration failed.")
    }
}
```

### Fetch Chat User List

To retrieve a list of users from a specific collection, use the `fetchChatUsers` method. Example:

```swift
QLFirebaseManager.shared.fetchChatUsers(with: "usersCollectionName") { documents in
    if let users = documents {
        print("Fetched \(users.count) users.")
    } else {
        print("Failed to fetch users.")
    }
}
```

### Initate a Chat 

To create chat individual or in group, use the createChat method. Provide the group data, unique ID, and collection type. Example:

```swift
QLFirebaseManager.shared.createChat(with: groupData, collection: .groups) { isSuccess in
    if isSuccess {
        print("Group creation successful.")
    } else {
        print("Group creation failed.")
    }
}
```

### Get Chat User Details

To retrieve user details by UID, you can use the `getChatUserDetail` method. Provide the UID and the field type (e.g., `.UID`) to identify the user. Example:

```swift
QLFirebaseManager.shared.getChatUserDetail(with: "userUID", type: .UID) { userName, uid in
    if let userName = userName, let uid = uid {
        print("User Name: \(userName), User UID: \(uid)")
    } else {
        print("User details not found.")
    }
}
```

### Get Details of Logged In User

To obtain the current user's information, such as email or UID, you can use the `getLoggedInUserDetails` method. Specify the field type (e.g., .email, .UID, .displayName) to retrieve the desired information. Example:

```swift
let userEmail = QLFirebaseManager.shared.getLoggedInUserDetails(with: .email)
let userUID = QLFirebaseManager.shared.getLoggedInUserDetails(with: .UID)
let userDisplayName = QLFirebaseManager.shared.getLoggedInUserDetails(with: .displayName)

print("User Email: \(userEmail)")
print("User UID: \(userUID)")
print("User Display Name: \(userDisplayName)")
```
### Send Chat Message

To send a message to a receiver, use the sendMessage method. Provide the document ID (message identifier), message data, and the collection type (e.g., .messages) to store the message. Example:

```swift
QLFirebaseManager.shared.sendChatMessage(with: documentID, message: messageData, type: .messages) { isSuccess in
    if isSuccess {
        print("Message sent successfully.")
    } else {
        print("Message sending failed.")
    }
}
```
### Fetch Chat Messages

To retrieve messages for a specific document (e.g., a chat), you can use the fetchMessages method. Provide the document ID, and it will return a list of messages. Example:

```swift
QLFirebaseManager.shared.fetchChatMessages(with: documentID) { messages in
    if let messages = messages {
        print("Fetched \(messages.count) messages.")
        for message in messages {
            let messageText = message.data()["text"] as? String ?? ""
            let senderUID = message.data()["sender"] as? String ?? ""
            // Process and display message information
        }
    } else {
        print("Failed to fetch messages.")
    }
}
```

### Fetch Messages For IndividualChat

To retrieve all messages for an individual chat user, use the getIndividualChat method. Provide the user's identifier (e.g., UID), and it will return a list of messages. Example:

```swift
QLFirebaseManager.shared.fetchMessagesForIndividualChat(user: userUID) { messages in
    if let messages = messages {
        print("Fetched \(messages.count) messages for user \(userUID).")
        for message in messages {
            let messageText = message.data()["text"] as? String ?? ""
            let senderUID = message.data()["sender"] as? String ?? ""
            // Process and display message information
        }
    } else {
        print("Failed to fetch messages for user \(userUID).")
    }
}
```
## Requirements
- **iOS 15.0+**
- **Swift 5.0+**
