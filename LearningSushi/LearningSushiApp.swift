//
//  LearningSushiApp.swift
//  LearningSushi
//
//  Created by win win on 24/04/24.
//

import SwiftUI

@main
struct LearningSushiApp: App {
    @StateObject var nearestdevices = DeviceFinderViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(nearestdevices)
    }
}
