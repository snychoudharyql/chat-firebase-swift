//
//  FirebaseChatExampleApp.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 15/09/23.
//

import SwiftUI
import QLFirebaseChat

@main
struct FirebaseChatExampleApp: App {
    init() {
        QLChatFirebase.initialize()
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if UserDefaults.standard.bool(forKey: userStatus) {
                   DashboardView()
                } else {
                   LoginView()
                 }
            }
        }
    }
}

