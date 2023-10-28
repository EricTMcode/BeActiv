//
//  BeActivApp.swift
//  BeActiv
//
//  Created by Eric on 26/10/2023.
//

import SwiftUI

@main
struct BeActivApp: App {
    @StateObject var manager = HealthManager()
    
    var body: some Scene {
        WindowGroup {
            BeActivTabView()
                .environmentObject(manager)
        }
    }
}
