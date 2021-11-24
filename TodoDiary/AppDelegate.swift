//
//  AppDelegate.swift
//  TodoDiary
//
//  Created by Yu on 2021/11/24.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.red
        return true
    }
}
