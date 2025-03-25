//
//  StravaMonthlyActivityView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/25/25.
//

import SwiftUI
import StravaSwift
import Charts



struct StravaMonthlyActivityView: View {
    var token: OAuthToken?
    @State private var thisMonthHIITData: [ChartData] = []
    @State private var lastMonthHIITData: [ChartData] = []
    @StateObject private var stravaViewModel = StravaActivitiesViewModel()
    @State private var selectedData: ChartData? = nil
    @State private var dragLocation: CGPoint = .zero
    @State private var thisMonthHIITActivities: [ChartData] = []
    @State private var lastMonthHIITActivities: [ChartData] = []
    
    @State private var thisMonthHIITTotalTime: Double = 0
    @State private var lastMonthHIITTotalTime: Double = 0
    
    @State private var lastFour: String = ""
    @State private var formattedDate: String = ""
    
    let calendar = Calendar.current
    let today = Date()
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Monthly HIIT Activity")
                            .font(.title.bold())
                            .padding()
                    }
                    Spacer()
                }
                .offset(y:-60)
                
                VStack {
                    if stravaViewModel.isLoading {
                        LoadingAnimationView()
                    } else if stravaViewModel.activities.isEmpty {
                        Text("⚠️ No Activities Found")
                            .foregroundColor(.gray)
                            .padding()
                
                    
                    } else {
                        ZStack {
                            VStack {
                                Text("Last month moving time: \(Int(lastMonthHIITTotalTime))")
                                    .font(Font.custom("SF Pro", size: 14))
                                    .foregroundColor(.blue)
                                Text("This month moving time: \(Int(thisMonthHIITTotalTime))")
                                    .font(Font.custom("SF Pro", size: 14))
                                    .foregroundColor(.orange)
                            }
                            .offset(y:-100)
                            
                            // Last month chart
                            Chart {
                                ForEach(lastMonthHIITData) { item in
                                    LineMark(
                                        x: .value("Day", item.category),
                                        y: .value("Value", item.value)
                                    )
                                    .interpolationMethod(.catmullRom)
                                    .foregroundStyle(Color(hex: "00D9FF"))

                                    AreaMark(
                                        x: .value("Day", item.category),
                                        y: .value("Value", item.value)
                                    )
                                    .interpolationMethod(.catmullRom)
                                    .foregroundStyle(
                                        .linearGradient(
                                            Gradient(stops: [
                                                .init(color: Color(hex: "00D9FF").opacity(0.6), location: 0),
                                                .init(color: Color(hex: "00D9FF").opacity(0.0), location: 1)
                                            ]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                }
                            }
                            .chartXAxis(.hidden)
                            .chartYAxis(.hidden)
                            .chartPlotStyle { plotArea in
                                plotArea
                                    .background(.clear)
                            }
                            .chartOverlay { proxy in
                                GeometryReader { geo in
                                    if let last = lastMonthHIITData.last,
                                       let x = proxy.position(forX: last.category),
                                       let y = proxy.position(forY: last.value) {

                                        ZStack {
                                            // Glowing halo
                                            Circle()
                                                .fill(Color.blue.opacity(0.4))
                                                .frame(width: 24, height: 24)
                                                .blur(radius: 8)

                                            // Core dot
                                            Circle()
                                                .fill(Color.blue)
                                                .frame(width: 12, height: 12)
                                                .shadow(color: Color.blue.opacity(0.6), radius: 6, x: 0, y: 0)
                                        }
                                        .position(x: x, y: y - 5) // slightly lift the dot
                                    }
                                }
                            }

                            .frame(height: 150)
                            
                            // This month chart
                            Chart {
                                ForEach(thisMonthHIITData) { item in
                                    LineMark(
                                        x: .value("Day", item.category),
                                        y: .value("Value", item.value)
                                    )
                                    .interpolationMethod(.catmullRom)
                                    .foregroundStyle(Color(hex: "FF5D00"))

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
                            .chartPlotStyle { plotArea in
                                plotArea
                                    .background(.clear)
                            }
                            .chartOverlay { proxy in
                                GeometryReader { geo in
                                    if let last = thisMonthHIITData.last,
                                       let x = proxy.position(forX: last.category),
                                       let y = proxy.position(forY: last.value) {
                                        ZStack {
                                            // Glowing halo
                                            Circle()
                                                .fill(Color.orange.opacity(0.4))
                                                .frame(width: 24, height: 24)
                                                .blur(radius: 8)
                                            
                                            // Core dot
                                            Circle()
                                                .fill(Color.orange)
                                                .frame(width: 12, height: 12)
                                                .shadow(color: Color.orange.opacity(0.6), radius: 6, x: 0, y: 0)
                                        }
                                        .position(x: x, y: y - 1) // slightly lift the dot
                                        
                                    }
                                }
                            }
                            .frame(height: 150)
                        }
//                        .padding()
//                        
                        Button("Replay Animation") {
                            animateData()
                        }
                        .offset(y:-15)
                        .padding(.top)

                    }
                }
                .onAppear {
                    stravaViewModel.fetchActivities()
                }
            }
//            .offset(y:50)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))
            .onAppear {
                animateData()
            }
            .onChange(of: stravaViewModel.activities) {
                for activity in stravaViewModel.activities {
                    lastFour = String(activity.name?.suffix(4) ?? "")
                    
                    if let startDate = activity.startDate {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MM/dd"
                        let formattedDate = formatter.string(from: startDate)
                        
                        let thisMonth = formatter.string(from: today).prefix(2)
                        if let lastMonthDate = calendar.date(byAdding: .month, value: -1, to: today) {
                            let lastMonth = formatter.string(from: lastMonthDate).prefix(2)
                            let activityMonth = formattedDate.prefix(2)
                            
                            if thisMonth == activityMonth {
                                if lastFour == "HIIT" {
                                    print("This month HIIT | Month: \(activityMonth) | Moving Time: \(activity.movingTime ?? 0.0)")
                                    thisMonthHIITTotalTime += activity.movingTime ?? 0.0
                                    thisMonthHIITActivities.append(ChartData(category: String(formattedDate), value: activity.movingTime ?? 0.0))
                                }
                                
                                // Last Month
                            } else if lastMonth == activityMonth {
                                if lastFour == "HIIT" {
                                    print("Last month HIIT | Month: \(activityMonth) | Moving Time: \(activity.movingTime ?? 0.0)")
                                    lastMonthHIITTotalTime += activity.movingTime ?? 0.0
                                    lastMonthHIITActivities.append(ChartData(category: String(formattedDate), value: activity.movingTime ?? 0.0))
                                }
                            }
                        }
                    }
                }
                
                
                thisMonthHIITData = thisMonthHIITActivities.map { ChartData(category: $0.category, value: 0) }
                for (index, item) in thisMonthHIITActivities.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                        withAnimation(.easeOut(duration: 0.5)) {
                            thisMonthHIITData[index].value = item.value
                        }
                    }
                }
                
                lastMonthHIITData = lastMonthHIITActivities.map { ChartData(category: $0.category, value: 0) }
                for (index, item) in lastMonthHIITActivities.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                        withAnimation(.easeOut(duration: 0.5)) {
                            lastMonthHIITData[index].value = item.value
                        }
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
        thisMonthHIITData = thisMonthHIITActivities.map { ChartData(category: $0.category, value: 0) }
        selectedData = nil
        for (index, item) in thisMonthHIITActivities.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                withAnimation(.easeOut(duration: 0.5)) {
                    thisMonthHIITData[index].value = item.value
                }
            }
        }
        
        lastMonthHIITData = lastMonthHIITActivities.map { ChartData(category: $0.category, value: 0) }
        selectedData = nil
        for (index, item) in lastMonthHIITActivities.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                withAnimation(.easeOut(duration: 0.5)) {
                    lastMonthHIITData[index].value = item.value
                }
            }
        }
    }
}
    
