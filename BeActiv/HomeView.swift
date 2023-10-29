//
//  HomeView.swift
//  BeActiv
//
//  Created by Eric on 26/10/2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var manager: HealthManager
    let welcomeArray = ["Welcome", "Bienvenido", "Bienvenue"]
    @State private var currentIndex = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(welcomeArray[currentIndex])
                .font(.largeTitle)
                .padding()
                .foregroundStyle(.secondary)
                .animation(.easeInOut(duration: 1), value: currentIndex)
                .onAppear {
                    startWelcomeTimer()
                }
            
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                ForEach(manager.activites.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
                    ActivityCard(activity: item.value)
                }
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    func startWelcomeTimer() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % welcomeArray.count
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(HealthManager())
}
