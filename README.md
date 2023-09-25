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

```swift
QLChatFirebase.initialize()
```
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

Note: Ensure you have set up Firebase in your project by following the Firebase setup instructions provided by Firebase.

 ## Usage of Firebase Authentication:
 - Initialize an instance of FirebaseAuthManager\
   `let authManager = FirebaseAuthManager.shared'

 ### Register a New User

To register a new user, use the `registerUser` method. Provide the user's email and password as parameters. Here's an example:

```swift
authManager.registerUser(email: "user@example.com", password: "password") { result in
    switch result {
    case .success(let user):
        print("User registration successful. User ID: \(user.uid)")
    case .failure(let error):
        print("User registration failed with error: \(error.localizedDescription)")
    }
}
```
### Login an Existing User

To log in an existing user, use the `loginUser` method. Provide the user's email and password as parameters. Here's an example:

```swift
 authManager.loginUser(email: "user@example.com", password: "password") { result in
    switch result {
    case .success(let user):
        print("User login successful. User ID: \(user.uid)")
    case .failure(let error):
        print("User login failed with error: \(error.localizedDescription)")
    }
}
```
### Logout the Current User

To log out the current user, use the logoutUser method. Here's an example:

```swift
authManager.logoutUser { result in
    switch result {
    case .success:
        print("User logout successful.")
    case .failure(let error):
        print("User logout failed with error: \(error.localizedDescription)")
    }
}
```

## Usage of Firebase Manager

### Create a New User

To register a new user, use the addNewUser method. Provide the user's data, unique ID, and collection type. Example:

```swift
FirebaseManager.shared.addNewUser(with: userData, id: "uniqueUserID", collection: .users) { isSuccess in
    if isSuccess {
        print("User registration successful.")
    } else {
        print("User registration failed.")
    }
}
```

### Fetch User List

To retrieve a list of users from a specific collection, use the fetchUsers method. Example:

```swift
FirebaseManager.shared.fetchUsers(with: "usersCollectionName") { documents in
    if let users = documents {
        print("Fetched \(users.count) users.")
    } else {
        print("Failed to fetch users.")
    }
}
```

### Create a Group

To create a new group, use the createGroup method. Provide the group data, unique ID, and collection type. Example:

```swift
FirebaseManager.shared.createGroup(with: groupData, id: "uniqueGroupID", collection: .groups) { isSuccess in
    if isSuccess {
        print("Group creation successful.")
    } else {
        print("Group creation failed.")
    }
}
```

### Get User Details

To retrieve user details by UID, you can use the `getUserDetail` method. Provide the UID and the field type (e.g., `.UID`) to identify the user. Example:

```swift
FirebaseManager.shared.getUserDetail(forUID: "userUID", type: .UID) { userName, uid in
    if let userName = userName, let uid = uid {
        print("User Name: \(userName), User UID: \(uid)")
    } else {
        print("User details not found.")
    }
}
```

### Get Current User

To obtain the current user's information, such as email or UID, you can use the getCurrentUser method. Specify the field type (e.g., .email, .UID, .displayName) to retrieve the desired information. Example:

```swift
let userEmail = FirebaseManager.shared.getCurrentUser(with: .email)
let userUID = FirebaseManager.shared.getCurrentUser(with: .UID)
let userDisplayName = FirebaseManager.shared.getCurrentUser(with: .displayName)

print("User Email: \(userEmail)")
print("User UID: \(userUID)")
print("User Display Name: \(userDisplayName)")
```
### Send Message

To send a message to a receiver, use the sendMessage method. Provide the document ID (message identifier), message data, and the collection type (e.g., .messages) to store the message. Example:

```swift
FirebaseManager.shared.sendMessage(with: documentID, message: messageData, type: .messages) { isSuccess in
    if isSuccess {
        print("Message sent successfully.")
    } else {
        print("Message sending failed.")
    }
}
```
### Fetch Messages

To retrieve messages for a specific document (e.g., a chat), you can use the fetchMessages method. Provide the document ID, and it will return a list of messages. Example:

```swift
FirebaseManager.shared.fetchMessages(with: documentID) { messages in
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

### Get Individual Chat

To retrieve all messages for an individual chat user, use the getIndividualChat method. Provide the user's identifier (e.g., UID), and it will return a list of messages. Example:

```swift
FirebaseManager.shared.getIndividualChat(user: userUID) { messages in
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
