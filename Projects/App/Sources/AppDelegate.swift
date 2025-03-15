//
//  AppDelegate.swift
//  GitSearch
//
//  Created by 전성훈 on 3/11/25.
//

import UIKit

import Data
import Domain
import Core

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        _ = DataDIContainer.shared
        _ = CoreDIContainer.shared
        _ = DomainDIContainer.shared
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
}
