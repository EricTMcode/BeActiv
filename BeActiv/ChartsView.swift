//
//  ChartsView.swift
//  BeActiv
//
//  Created by Eric on 28/10/2023.
//

import Charts
import SwiftUI

struct DailyStepView: Identifiable {
    let id = UUID()
    let date: Date
    let stepCount: Double
}

enum ChartOptions {
    case oneWeek
    case oneMonth
    case threeMonth
    case yearToDate
    case oneYear
}

struct ChartsView: View {
    @EnvironmentObject var manager: HealthManager
    @State var selectedChart: ChartOptions = .oneMonth
    
    var body: some View {
        VStack(spacing: 12) {
            Chart {
                ForEach(manager.oneMonthChartData) { daily in
                    BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("Steps", daily.stepCount))
                }
            }
            .foregroundStyle(.green)
            .frame(height: 350)
            .padding(.horizontal)
            
            HStack {
                Button("1W") {
                    withAnimation {
                        selectedChart = .oneWeek
                    }
                }
                .padding(.all)
                .foregroundStyle(selectedChart == .oneWeek ? .white : .green)
                .background(selectedChart == .oneWeek ? .green : .clear)
                .cornerRadius(10)
                
                Button("1M") {
                    withAnimation {
                        selectedChart = .oneMonth
                    }
                }
                .padding(.all)
                .foregroundStyle(selectedChart == .oneMonth ? .white : .green)
                .background(selectedChart == .oneMonth ? .green : .clear)
                .cornerRadius(10)
                
                Button("3M") {
                    withAnimation {
                        selectedChart = .threeMonth
                    }
                }
                .padding(.all)
                .foregroundStyle(selectedChart == .threeMonth ? .white : .green)
                .background(selectedChart == .threeMonth ? .green : .clear)
                .cornerRadius(10)
                
                Button("YTD") {
                    withAnimation {
                        selectedChart = .yearToDate
                    }
                }
                .padding(.all)
                .foregroundStyle(selectedChart == .yearToDate ? .white : .green)
                .background(selectedChart == .yearToDate ? .green : .clear)
                .cornerRadius(10)
                
                Button("1Y") {
                    withAnimation {
                        selectedChart = .oneYear
                    }
                }
                .padding(.all)
                .foregroundStyle(selectedChart == .oneYear ? .white : .green)
                .background(selectedChart == .oneYear ? .green : .clear)
                .cornerRadius(10)
            }
            .padding(.top)
        }
        .onAppear {
            print(manager.oneMonthChartData)
        }
    }
}

#Preview {
    ChartsView()
        .environmentObject(HealthManager())
}
