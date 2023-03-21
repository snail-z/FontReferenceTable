//
//  AppDelegate.swift
//  Lento
//
//  Created by corgi on 2022/7/4.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        let backIMage = UIImage(named: "back_icon")
//        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backIMage, for: .normal, barMetrics: .default)
//        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: .leastNormalMagnitude, vertical: .leastNormalMagnitude), for: .default)
//
//        UINavigationBar.appearance().backIndicatorImage = UIImage()
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage()
        
//        if #available(iOS 15.0, *) {
//            let navigationBarAppearance = UINavigationBarAppearance()
//            let backIMage = UIImage(named: "back_light")
//            navigationBarAppearance.setBackIndicatorImage(backIMage, transitionMaskImage: backIMage)
//            UINavigationBar.appearance().tintColor = .red
//            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
//            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            
//        }
        
        let tabbarVC = LentoBaseTabBarController()
        window?.rootViewController = tabbarVC
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func configTabbarController() {
        
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
