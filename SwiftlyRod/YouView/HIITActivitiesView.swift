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
                        Text("HIIT Stats")
                            .font(.title.bold())
                            .padding()
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
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                    .chartOverlay { proxy in
                        GeometryReader { geo in
                            
                            // 🔵 End-of-line pulse
                            if let last = HIITCaloriesData.last,
                               let x = proxy.position(forX: last.category),
                               let y = proxy.position(forY: last.value) {
                                
                                ZStack {
                                    Circle()
                                        .fill(Color.orange.opacity(0.4))
                                        .frame(width: 24, height: 24)
                                        .blur(radius: 8)
                                    
                                    Circle()
                                        .fill(Color.orange)
                                        .frame(width: 12, height: 12)
                                        .shadow(color: Color.orange.opacity(0.6), radius: 6)
                                }
                                .position(x: x, y: y - 5)
                            }
                            
                            // 🟢 Highlight highest-calorie day
                            if let maxItem = highestCalorieEntry,
                               let x = proxy.position(forX: maxItem.category),
                               let y = proxy.position(forY: maxItem.value) {
                                
                                ZStack {
                                    Circle()
                                        .fill(Color.green.opacity(0.4))
                                        .frame(width: 28, height: 28)
                                        .blur(radius: 10)
                                    
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 14, height: 14)
                                        .shadow(color: Color.green.opacity(0.6), radius: 6)
                                    
                                    Text("\(Int(maxItem.value))")
                                        .font(.caption2.bold())
                                        .foregroundColor(.green)
                                        .offset(y: -25)
                                }
                                .position(x: x, y: y - 5)
                            }
                        }
                    }
                    .frame(height: 150)
                    

                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .onChange(of: homeViewModel.currentMonthWorkouts.count) {
                    updateHIITData()
                }
                
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
}
