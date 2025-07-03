//
//  MediTrackApp.swift
//  MediTrack
//
//  Created by Emre Erdem on 3.07.2025.
//

import SwiftUI

@main
struct MediTrackApp: App {
    init() {
        // Bildirim izinlerini iste
        NotificationService.shared.requestAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
