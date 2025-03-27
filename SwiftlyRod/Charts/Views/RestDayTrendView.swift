//
//  RestDayTrendView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/26/25.
//

import Foundation
import SwiftUI
import StravaSwift
import Charts

struct restDayChartData: Identifiable {
    let id = UUID()
    let date: Date
    let movingTime: Double
}

// Model for a single day
struct Day: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let isCompleted: Bool
}

// View for each square
struct DaySquareView: View {
    var day: Day
    
    var body: some View {
        Rectangle()
            .frame(width: 30, height: 30)
            .foregroundColor(day.isCompleted ? Color(hex: "FF5722") : .gray)
            .overlay(
                Text("\(Calendar.current.component(.day, from: day.date))")
                    .font(.caption2)
                    .foregroundColor(.white)
            )
    }
}

// Grid for the current month
struct MonthGridView: View {
    let days: [Day]
    
    // 7 columns for 7 days of the week
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 5) {
            ForEach(days) { day in
                DaySquareView(day: day)
            }
        }
        .padding()
    }
}


struct RestDayTrendView: View {
    var token: OAuthToken?
    
    @State private var thisMonthData: [Day] = []
    @State private var thisMonthActivities: [String:Bool] = [:]
    @StateObject private var stravaViewModel = StravaActivitiesViewModel()
    
    @State private var lastFour: String = ""
    @State private var formattedDate: String = ""
    @State private var monthName: String = ""
    @State private var totalRestDays: Int = 0
    @State private var totalTrainingDays: Int = 0
    
    @State private var days: [Day] = []
    let calendar = Calendar.current
    let today = Date()
    let formatter = DateFormatter()
    
    var body: some View {

        GeometryReader { geometry in
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Text("Recovery vs. Training")
                            .font(.title.bold())
                            .padding()
                        Spacer()
                    }
                    Spacer()
                }
                VStack {
                    Text("\(monthName) 2025")
                        .font(Font.custom("SF Pro", size: 18))
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .offset(x:85, y:55)
                    HStack {
                        MonthGridView(days: days)
                            .scaleEffect(0.75)
                            .padding()
                    }
                    Text("Total Training: \(totalTrainingDays) | Total Rest days: \(totalRestDays)")
                        .font(Font.custom("SF Pro", size: 14))
                        .foregroundColor(.white)
                        .offset(y:-40)
                }
                
                VStack {
                    HStack {
                        Text("Rest Day")
                            .font(Font.custom("SF Pro", size: 14))
                            .font(.title.bold())
                            .foregroundColor(.white)
                        Rectangle()
                            .frame(width: 20, height: 10)
                            .foregroundColor(.gray)
                        
                    }
                    .offset(x:65 ,y:65)
                    
                    HStack {
                        Text("Active Day")
                            .font(Font.custom("SF Pro", size: 14))
                            .font(.title.bold())
                            .foregroundColor(.white)
                        Rectangle()
                            .frame(width: 20, height: 10)
                            .foregroundColor(Color(hex: "FF5722"))
                        
                    }
                    .offset(x:70 ,y:70)
                }
            }
            .onAppear {
                stravaViewModel.fetchActivities()
            }
            .background(Color.gray.opacity(0.1))
            .onChange(of: stravaViewModel.activities) {
                for activity in stravaViewModel.activities {
                    formatter.dateFormat = "MMMM"
                    monthName = formatter.string(from: today)

//                    lastFour = String(activity.name?.suffix(4) ?? "")
//
                    guard let startDate = activity.startDate else { continue }
                    formatter.dateFormat = "MM/dd"
                    let formattedDate = formatter.string(from: startDate)
//
//                    let movingTime = activity.movingTime ?? 0.0
//
//                    print("RestDays chart: \(formattedDate) | moving time: \(movingTime)")
//                    if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
//                    }
                    thisMonthActivities[formattedDate] = true
//                    print("activityDate: ", activity.startDate, "isComplete: \(formattedDate)")
                    
                    
                    
//                    thisMonthActivities.append(Day(date: startDate, isCompleted: true))

                }
                print(thisMonthActivities)
                generateDaysForCurrentMonth()
            }
        }

    }
    
    func generateDaysForCurrentMonth() -> [Day] {
        let calendar = Calendar.current
        let today = Date()
        let range = calendar.range(of: .day, in: .month, for: today)!
        let components = calendar.dateComponents([.year, .month], from: today)
        let startOfMonth = calendar.date(from: components)!
        formatter.dateFormat = "MM/dd"
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                formatter.dateFormat = "MM/dd"
                let formattedDate = formatter.string(from: date)
                
                let isCompleted = thisMonthActivities[String(formattedDate)] ?? false

                days.append(Day(date: date, isCompleted: isCompleted))
                
                if !isCompleted {
                    totalRestDays += 1
                } else {
                    totalTrainingDays += 1
                }
            }
        }
        return days
    }
}
