//
//  SceneDelegate.swift
//  WhatToDo Planner
//
//  Created by Vladimir Grigoryev on 15.01.2025.
//


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let keychainService = KeychainService()
        let tokenKey = "userToken"
        
        let welcomeVC = WelcomeModuleAssembly.assembly() // Build WelcomeViewController
        let navigationController = UINavigationController(rootViewController: welcomeVC) // Embed in navigation controller
        window.rootViewController = navigationController
        
//        var rootVC: UIViewController
//        if let data = keychainService.getData(forKey: tokenKey),
//           let token = String(data: data, encoding: .utf8),
//           let expDate = decodeJWTExpiration(token),
//           expDate > Date() {
//            rootVC = MainAssembly.assembly()
//        } else {
//            rootVC = WelcomeModuleAssembly.assembly()
//        }
//        
//        let nav = UINavigationController(rootViewController: rootVC)
//        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }
    
    /// Decoding payload JWT and returning "exp" Date
    func decodeJWTExpiration(_ token: String) -> Date? {
        let segments = token.split(separator: ".")
        guard segments.count > 1 else { return nil }

        // Take second part (payload), adding for Base64 and decoding
        var base64 = String(segments[1])
        let remainder = base64.count % 4
        if remainder > 0 {
            base64 += String(repeating: "=", count: 4 - remainder)
        }
        guard let payloadData = Data(base64Encoded: base64),
              let json = try? JSONSerialization.jsonObject(with: payloadData) as? [String: Any],
              let exp = json["exp"] as? TimeInterval
        else {
            return nil
        }
        // exp returning as UNIX-timestamp (seconds)
        return Date(timeIntervalSince1970: exp)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
