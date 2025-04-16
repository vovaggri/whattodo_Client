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
        let welcomeVC = WelcomeModuleAssembly.assembly() // Build WelcomeViewController
        let navigationController = UINavigationController(rootViewController: welcomeVC) // Embed in navigation controller
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
    
    
    
    
    
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//
//        let window = UIWindow(windowScene: windowScene)
//
//        // Mock task for preview
//        let mockTask = Task(
//            id: 1,
//            title: "Gym Session",
//            description: "Leg day workout 🦵",
//            colour: ColorIDs.ultraPink,
//            endDate: Date(),
//            done: false,
//            startTime: Date(),
//            endTime: Calendar.current.date(byAdding: .hour, value: 1, to: Date()),
//            goalId: 2
//        )
//
//        let reviewVC = ReviewScreenAssembly.assembly(mockTask)
//        let nav = UINavigationController(rootViewController: reviewVC)
//
//        window.rootViewController = nav
//        self.window = window
//        window.makeKeyAndVisible()
//    }

//        let window = UIWindow(windowScene: windowScene)
//
//        let successVC = SuccessScreenConfigurator.configureModule()
//        let navigationController = UINavigationController(rootViewController: successVC)
//        window.rootViewController = navigationController
//        self.window = window
//        window.makeKeyAndVisible()
//        
//        let window = UIWindow(windowScene: windowScene)
//        let confirmVC = ConfirmModuleAssembly.assembly()
//        let navigationController = UINavigationController(rootViewController: confirmVC)
//        window.rootViewController = navigationController
//        self.window = window
//        window.makeKeyAndVisible()
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
