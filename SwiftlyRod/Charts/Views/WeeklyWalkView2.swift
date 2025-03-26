//
//  WeeklyWalkView2.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/25/25.
//

import SwiftUI
import Charts



struct InteractiveLineChartView: View {
    @State private var data: [ChartData] = []
    @State private var selectedData: ChartData? = nil
    @State private var dragLocation: CGPoint = .zero

    @StateObject var chartsViewModel = ChartsViewModel()
    @State private var dotOpacity: Double = 1.0
    @State private var dotPosition: CGPoint = .zero

    @State private var sampleData: [ChartData] = []

    var body: some View {
        VStack {
            Text("Weekly Step Summary")
                .font(.title.bold())
                .padding()

            ZStack {
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
                                    .init(color: Color(hex: "FF5D00").opacity(0.6), location: 0),
                                    .init(color: Color(hex: "FF5D00").opacity(0.0), location: 1)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .chartOverlay { proxy in
                    GeometryReader { geo in
                        Rectangle()
                            .fill(Color.clear)
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        let location = value.location

                                        if let xCategory: String = proxy.value(atX: location.x) {
                                            let allCategories = sampleData.map { $0.category }
                                            guard let xIndex = allCategories.firstIndex(of: xCategory) else { return }

                                            let xPos = Double(xIndex)
                                            if let yVal = interpolatedY(atX: xPos, in: sampleData),
                                               let posX = proxy.position(forX: xCategory),
                                               let posY = proxy.position(forY: yVal) {

                                                withAnimation(.easeInOut(duration: 0.15)) {
                                                    self.selectedData = ChartData(category: xCategory, value: yVal)
                                                    self.dragLocation = CGPoint(x: posX, y: posY - 13)
                                                }
                                            }
                                        }
                                    }
                            )

                        if let selected = selectedData {
                            // Tooltip and glowing dot
                            VStack(spacing: 4) {
                                Text("Steps: \(Int(selected.value))")
                                    .font(.caption)
                                    .padding(6)
                                    .background(Color.black.opacity(0.8))
                                    .cornerRadius(6)

                                ZStack {
                                    // Glowing halo
                                    Circle()
                                        .fill(Color.orange.opacity(0.4))
                                        .frame(width: 24, height: 24)
                                        .blur(radius: 8)

                                    // Actual dot
                                    Circle()
                                        .fill(Color.orange)
                                        .frame(width: 12, height: 12)
                                        .shadow(color: Color.orange.opacity(0.6), radius: 6, x: 0, y: 0)
                                }
                                
                            }
                            .position(dragLocation)

                        }
                    }
                }
                .frame(height: 300)
            }
            .padding()

            Button("Replay Animation") {
                animateData()
            }
            .padding(.top)
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
//        .cornerRadius(25.0)
        .onAppear {
            animateData()
        }
        .onChange(of: chartsViewModel.oneWeekChartData.count) {
            for data in chartsViewModel.oneWeekChartData {
                if let startDate = data.date as Date? {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MM/dd"
                    let formattedDate = formatter.string(from: startDate)
                    sampleData.append(ChartData(category: formattedDate, value: Double(data.count)))
                }
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

    // MARK: - Value interpolation
    func interpolatedY(atX xValue: Double, in data: [ChartData]) -> Double? {
        let indexBefore = Int(floor(xValue))
        let indexAfter = Int(ceil(xValue))

        guard indexBefore >= 0, indexAfter < data.count else { return nil }

        let y1 = data[indexBefore].value
        let y2 = data[indexAfter].value

        let ratio = xValue - Double(indexBefore)
        return y1 + ratio * (y2 - y1)
    }

    // MARK: - Animate Data Load
    private func animateData() {
        data = sampleData.map { ChartData(category: $0.category, value: 0) }
        selectedData = nil
        for (index, item) in sampleData.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                withAnimation(.easeOut(duration: 0.5)) {
                    data[index].value = item.value
                }
            }
        }
    }
}

// Optional: distance helper if you want to expand category matching
extension String {
    func distanceFrom(_ other: String, in all: [String]) -> Int {
        guard let i1 = all.firstIndex(of: self), let i2 = all.firstIndex(of: other) else {
            return Int.max
        }
        return abs(i1 - i2)
    }
}



struct ChartData: Identifiable {
    let id = UUID()
    let category: String
    var value: Double
}

