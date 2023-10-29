//
//  BeActivTabView.swift
//  BeActiv
//
//  Created by Eric on 26/10/2023.
//

import SwiftUI

struct BeActivTabView: View {
    @EnvironmentObject var manager: HealthManager
    @State var selectedTab = "Home"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .environmentObject(manager)
                .tag("Home")
                .tabItem { Image(systemName: "house") }
                
            
            ChartsView()
                .environmentObject(manager)
                .tag("Charts")
                .tabItem { Image(systemName: "chart.line.uptrend.xyaxis") }
            
            ContentView()
                .tag("Content")
                .tabItem { Image(systemName: "person") }
        }
    }
}

#Preview {
    BeActivTabView()
        .environmentObject(HealthManager())
}
