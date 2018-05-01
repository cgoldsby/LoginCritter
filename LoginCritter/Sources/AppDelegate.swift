//
//  AppDelegate.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 3/30/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setUpWindow()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }

    // MARK: - Private

    private func setUpWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = LoginViewController()
        window?.makeKeyAndVisible()
    }
}
