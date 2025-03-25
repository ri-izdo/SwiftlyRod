//
//  WeeklyWalkingView3.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/25/25.
//

import SwiftUI
import Charts


struct WeeklyWalkView3: View {
    @State private var data: [ChartData] = []
    @StateObject var chartsViewModel = ChartsViewModel()
    @State private var dotOpacity: Double = 1.0
    @State private var dotPosition: CGPoint = .zero
    @State private var sampleData: [ChartData] = []

    var body: some View {
        GeometryReader { geometry in
                
            VStack {
                Chart {
                    ForEach(data) { item in
                        LineMark(
                            x: .value("Day", item.category),
                            y: .value("Value", item.value)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(.orange)
                        
                        AreaMark(
                            x: .value("Day", item.category),
                            y: .value("Value", item.value)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(
                            .linearGradient(
                                Gradient(stops: [
                                    .init(color: .orange.opacity(0.6), location: 0),
                                    .init(color: .orange.opacity(0.0), location: 1)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                }
                .chartOverlay { proxy in
                    GeometryReader { geo in
                        if let last = data.last {
                            let x = proxy.position(forX: last.category) ?? 0
                            let y = proxy.position(forY: last.value) ?? 0
                            
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 12, height: 12)
                                .opacity(dotOpacity)
                                .position(x: x, y: y)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                                        dotOpacity = 0.2
                                        
                                        
                                    }
                                }
                        }
                    }
                            
                        
                            .frame(height: 300)
                            .padding()
                            .onAppear {
                                animateData()
                            }
                            .onChange(of: chartsViewModel.oneWeekChartData.count) {
                                for data in chartsViewModel.oneWeekChartData {
                                    sampleData.append(ChartData(category: String(data.date.formatted()), value: Double(data.count)))
                                }
                                data = sampleData.map { ChartData(category: $0.category, value: 0) }
                                for (index, item) in sampleData.enumerated() {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                                        withAnimation(.easeOut(duration: 0.5)) {
                                            data[index].value = item.value
                                        }
                                    }
                                }
                            }
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                
        }
    }
    
    private func animateData() {
        data = sampleData.map { ChartData(category: $0.category, value: 0) }
        for (index, item) in sampleData.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                withAnimation(.easeOut(duration: 0.5)) {
                    data[index].value = item.value
                }
            }
        }
    }
}


