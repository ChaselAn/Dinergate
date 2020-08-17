//
//  AppDelegate.swift
//  APMDemo
//
//  Created by 安程 on 2020/8/14.
//  Copyright © 2020 ChaselAn. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow()
        self.window?.backgroundColor = .white
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
//        self.window.backgroundColor = [UIColor whiteColor];
//        [self.window makeKeyAndVisible];
//
//        SKTabbarController * tabVC = [[SKTabbarController alloc] init];
//        self.window.rootViewController = tabVC;

        return true
    }

}

