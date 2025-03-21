//
//  WalkStatsView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/17/25.
//

import SwiftUI
import StravaSwift
import Charts


struct WalkStatsView: View {
    let distances = [0.21, 0.42, 0.63, 0.1,0.5]
    
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
                    Text("Total walks: \(distances.count)")
                        .font(Font.custom("SF Pro", size: 12))
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    
                    ChartView(distances: distances)
                        .frame(maxWidth: geometry.size.width)
                }
                    
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.3))
            
        }
    }
}


struct ChartView: View {
    let distances: [Double]
    @State private var animatedDistances: [Double] = []

    var body: some View {
        Chart {
            ForEach(Array(animatedDistances.enumerated()), id: \.0) { index, value in
                LineMark(
                    x: .value("Index", index),
                    y: .value("Distance", value)
                )
                .foregroundStyle(gradientColor(for: value))
                
                PointMark(
                    x: .value("Index", index),
                    y: .value("Distance", value)
                )
                .foregroundStyle(Color.white)
                .symbol(Circle())
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) {
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
                    .foregroundStyle(.white)
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom) {
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
                    .foregroundStyle(.white)
            }
        }
        .padding()
        .onAppear {
            resetGraphAnimation()
        }
    }

    // Function to reset and reanimate the graph
    func resetGraphAnimation() {
        animatedDistances = distances.map { _ in 0 } // Reset to zero
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 3)) {
                animatedDistances = distances
            }
        }
    }


    // Function to generate a color gradient based on distance value
    private func gradientColor(for value: Double) -> LinearGradient {
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue]
        let index = min(Int(value * Double(colors.count)), colors.count - 1)
        return LinearGradient(
            gradient: Gradient(colors: [colors[index], colors[max(index - 1, 0)]]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
