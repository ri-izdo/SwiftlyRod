//
//  HIITActivitiesView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/25/25.
//
import SwiftUI
import Charts

struct HIITChartData: Identifiable {
    let id = UUID()
    let category: String
    var value: Double
}

struct HIITActivitiesView: View {
    @StateObject private var homeViewModel = MonthWorkoutsViewModel()
    @State private var HIITCaloriesWorkout: [HIITChartData] = []
    @State private var HIITCaloriesData: [HIITChartData] = []
    @State private var chartVisible = false

    
    @State private var monthName: String = ""
    let calendar = Calendar.current
    let today = Date()
    
    // 🔥 Highlight the highest-calorie day
    var highestCalorieEntry: HIITChartData? {
        HIITCaloriesData.max(by: { $0.value < $1.value })
    }
    
    var spacedDateLabels: [String] {
        let total = HIITCaloriesData.count
        let count = 5
        guard total > 1 else { return [] }

        let step = max(1, total / (count - 1))

        return (0..<count).compactMap { i in
            let index = min(i * step, total - 1)
            return HIITCaloriesData[index].category
        }
    }


    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("HIIT \(monthName) Summary")
                            .font(.title.bold())
                            .padding()
                            .onAppear {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "MMMM" // or "MMM" for short version
                                monthName = formatter.string(from: today)
                            }
                    }
                    Spacer()
                }
                
                VStack {
                    Chart {
                        ForEach(HIITCaloriesData) { item in
                            LineMark(
                                x: .value("Day", item.category),
                                y: .value("Value", item.value)
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(Color(hex: "FF5722"))
                            
                            AreaMark(
                                x: .value("Day", item.category),
                                y: .value("Value", item.value)
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(
                                .linearGradient(
                                    Gradient(stops: [
                                        .init(color: Color(hex: "FF5722").opacity(0.6), location: 0),
                                        .init(color: Color(hex: "FF5722").opacity(0.0), location: 1)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        }
                    }
                    .opacity(chartVisible ? 1 : 0)
                    .animation(.easeOut(duration: 0.6), value: chartVisible)
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                    .chartOverlay { proxy in
                        GeometryReader { geo in
                            if let maxItem = highestCalorieEntry,
                               let x = proxy.position(forX: maxItem.category),
                               let y = proxy.position(forY: maxItem.value) {
                                HIITChartCallout(x: x, y: y, chartWidth: geo.size.width, value: Int(maxItem.value))
                            }
                        }
                    }
                    .offset(y:20)

                    .frame(height: 150)
                    
                    // Show 5 date labels below the chart
                    HStack {
                        ForEach(spacedDateLabels, id: \.self) { label in
                            Text(label)
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 8)
                    .offset(y:30)
                    

                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .onChange(of: homeViewModel.currentMonthWorkouts.count) {
                    updateHIITData()
                }
                
            }
            .onAppear {
                updateHIITData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation {
                        chartVisible = true
                    }
                }
            }
        }
    }

    func updateHIITData() {
        HIITCaloriesWorkout = []

        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"

        // Step 1: Parse workouts into a dictionary
        var caloriesByDate: [String: Double] = [:]
        for workout in homeViewModel.currentMonthWorkouts {
            if workout.title == "Other" {
                let formattedDate = formatter.string(from: workout.date)
                let calories = Double(workout.calories.replacingOccurrences(of: " kcal", with: "")) ?? 0
                caloriesByDate[formattedDate] = calories
            }
        }

        // Step 2: Generate all days in the current month
        guard let range = calendar.range(of: .day, in: .month, for: today),
              let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))
        else { return }

        var completeData: [HIITChartData] = []

        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                let formattedDate = formatter.string(from: date)
                let calories = caloriesByDate[formattedDate] ?? 0
                completeData.append(HIITChartData(category: formattedDate, value: calories))
            }
        }

        // Step 3: Animate values from 0 to actual
        HIITCaloriesData = completeData.map { HIITChartData(category: $0.category, value: 0) }

        for (index, item) in completeData.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                withAnimation(.easeOut(duration: 0.3)) {
                    HIITCaloriesData[index].value = item.value
                }
            }
        }
    }
    
    @ViewBuilder
    func makeCalloutLabel(value: Int) -> some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(Color.white)
            .overlay(
                Text("\(value) kcal")
                    .font(.caption2.bold())
                    .foregroundColor(.orange)
                    .padding(.horizontal, 8)
            )
            .frame(width: 80, height: 24)
    }
}

struct HIITChartCallout: View {
    let x: CGFloat
    let y: CGFloat
    let chartWidth: CGFloat
    let value: Int

    var body: some View {
        let lineY = y - 5
        let labelWidth: CGFloat = 80
        let labelPadding: CGFloat = 8
        let labelX = min(x + 70, chartWidth - labelWidth - labelPadding)

        return ZStack(alignment: .topLeading) {
            // 🟠 Highlighted dot
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.4))
                    .frame(width: 28, height: 28)
                    .blur(radius: 10)

                Circle()
                    .fill(Color.orange)
                    .frame(width: 14, height: 14)
                    .shadow(color: Color.orange.opacity(0.6), radius: 6)
            }
            .position(x: x, y: lineY)

            // ➖ Horizontal dashed line
            Path { path in
                path.move(to: CGPoint(x: 0, y: lineY))
                path.addLine(to: CGPoint(x: labelX - 4, y: lineY))
            }
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
            .foregroundColor(Color.orange.opacity(0.5))

            // ⬇️ Vertical dashed line
            Path { path in
                path.move(to: CGPoint(x: x, y: lineY + 5))
                path.addLine(to: CGPoint(x: x, y: 150)) // assume chart height
            }
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
            .foregroundColor(Color.orange.opacity(0.4))

            // 📍 Animated Label
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.white)
                .overlay(
                    Text("\(value) kcal")
                        .font(.caption2.bold())
                        .foregroundColor(.orange)
                        .padding(.horizontal, 8)
                )
                .frame(width: labelWidth, height: 24)
                .position(x: labelX + labelWidth / 2, y: lineY - 1)
                .transition(.opacity.combined(with: .move(edge: .top)))
                .animation(.easeOut(duration: 0.4), value: value)
        }
    }
}

