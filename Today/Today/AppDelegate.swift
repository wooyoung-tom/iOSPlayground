//
//  AppDelegate.swift
//  Today
//
//  Created by 최우영 on 2023/03/27.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // change the tint color of the navigation bar's default appearance.
        UINavigationBar.appearance().tintColor = .todayPrimaryTint
        
        // change the background color of the navigation bar's default appearance.
        UINavigationBar.appearance().backgroundColor = .todayNavigationBackground
        
        let navBarAppearance = UINavigationBarAppearance()
        
        // configure the navigation bar with opaque colors that are appropriate for the current theme.
        navBarAppearance.configureWithOpaqueBackground()
        
        // make the new appearance the default scroll edge appearance.
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

