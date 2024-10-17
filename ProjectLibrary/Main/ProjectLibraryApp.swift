//
//  ProjectLibraryApp.swift
//  ProjectLibrary
//
//  Created by Freddy Morales on 03/10/24.
//

import SwiftUI

@main
struct ProjectLibraryApp: App {
    // Integración del AppDelegate
        @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        // Limita las orientaciones solo a horizontal (landscape)
        return .landscape
    }
}
