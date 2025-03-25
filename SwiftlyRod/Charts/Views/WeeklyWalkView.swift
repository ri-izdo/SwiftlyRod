//
//  WeeklyWalkView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/24/25.
//

import Foundation
import Foundation
import SwiftUI
import Charts
import RiveRuntime

struct WeeklyWalkView: View {
    @StateObject var chartsViewModel = ChartsViewModel()
    @State private var riveWeeklyChart = RiveViewModel(fileName: "weekly_walk_graph", stateMachineName: "State Machine 1")
    @State private var inputName: String = ""
    
    

    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack {
                    Text("Walking Summary")
                        .font(Font.custom("SF Pro", size: 18))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                        .frame(height: 0.3)
                        .background(Color.white)
                        .offset(y: -15)
                }
                ZStack {
                    DailyActivityView()
                        .frame(width: 200, height: 200)
                        .offset(x:-250)
                        .scaleEffect(0.6)
                    VStack {
                        riveWeeklyChart.view()
                            .scaleEffect(1.5)
                        
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))
            .onChange(of: chartsViewModel.oneWeekChartData.count) {
                riveWeeklyChart.stop()
                for (index, data) in chartsViewModel.oneWeekChartData.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                        inputName = "StateBar-\(String(index+1))"
                        riveWeeklyChart.setInput(String(inputName), value: CGFloat(data.count))
                        print("Animating \(inputName) steps: \(data.count)")
                    }
                }
                riveWeeklyChart.setInput("Thickness", value: CGFloat(100.0))
//                riveWeeklyChart.play()
            }
                
        }
    }
}
