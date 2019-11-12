//
//  AppDelegate.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/15/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private lazy var rootNavigationController = AppNavigationController()
    private lazy var appearanceManager = AppearanceManager.recovered
    private lazy var realtimeDatabase = RealtimeDatabase(isPersistenceEnabled: true)
    private lazy var gradientWindow = V_GradientWindow(frame: UIScreen.main.bounds).config {
        $0.rootViewController = rootNavigationController
        $0.setColors(appearanceManager.gradientColors, animated: false)
        $0.makeKeyAndVisible()
    }
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        DependencyManager {
            Module { self.realtimeDatabase }
            Module { self.appearanceManager }
            Module { self.gradientWindow }
        }.build()
        
        window = gradientWindow
        
        if Auth.auth().currentUser != nil {
            VC_Tabs().loadAsRoot()
        } else {
            VC_Auth().loadAsRoot()
        }
        
        print("Environment: \(Environment.current.rawValue)")
        
        return true
    }

}
