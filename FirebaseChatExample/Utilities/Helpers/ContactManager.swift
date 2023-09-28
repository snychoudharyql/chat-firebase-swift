//
//  ContactManager.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 21/09/23.
//

import Foundation
import Contacts

class ContactManager {
    
    //MARK: - Properties
    
    public static let shared = ContactManager()
    
    // MARK: requestAccessToContacts
    
    func fetchContacts(completion: @escaping ([User]) -> Void){
        let contactStore = CNContactStore()
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            // Access is already granted, fetch the contacts.
            fetchUsers(from: contactStore) { fetchUser in
                completion(fetchUser)
            }
        case .notDetermined:
            // Request access to the contacts.
            contactStore.requestAccess(for: .contacts) { (granted, error) in
                if granted {
                    // Access granted, fetch the contacts.
                    self.fetchUsers(from: contactStore) { fetchUser in
                        completion(fetchUser)
                    }

                } else {
                    // Access denied.
                    print("Access to contacts denied.")
                }
            }
        case .denied, .restricted:
            // Access denied or restricted by the user.
            print("Access to contacts denied.")
            
        @unknown default:
            debugPrint("Unable to access request of contacts.")
        }
        

    }
    
    // MARK: fetchUsers
   
    private func fetchUsers(from contactStore: CNContactStore, completion: @escaping ([User]) -> Void) {
        var users: [User] = []
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
        
        DispatchQueue.global(qos: .background).async {
            do {
                try contactStore.enumerateContacts(with: request) { (contact, stop) in
                    // Map contact data to User model
                    let user = User()
                    user.name = "\(contact.givenName)"
                    user.email = contact.emailAddresses.first?.value as String?
                    users.append(user)
                }
                
                DispatchQueue.main.async {
                    completion(users)
                }
            } catch {
                print("Error fetching contacts: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }

    
}
