//
//  TodoDiaryApp.swift
//  TodoDiary
//
//  Created by Yu on 2021/11/24.
//

import Foundation
import SwiftUI

@main
struct TodoDiaryApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
