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

    @State private var previousMonthName: String = ""
    @State private var monthName: String = ""
    
    let calendar = Calendar.current
    let today = Date()
    
    
    
    

    var body: some View {
        GeometryReader { geometry in
            var maxYValue: Double {
                let allValues = thisMonthHIITData.map(\.value) + lastMonthHIITData.map(\.value)
                return allValues.max() ?? 100
            }

            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Text("Total Moving Time")
                            .font(.title.bold())
                            .padding()
                        Spacer()
                    }
                    HStack {
                        Text("\(previousMonthName) HITT \(Int(lastMonthHIITTotalTime))")
                            .font(Font.custom("SF Pro", size: 14))
                            .font(.title.bold())
                        //                                    .frame(maxWidth: .infinity, alignment:.trailing)
                            .foregroundColor(.gray)
                        
                        Text("\(monthName) HIIT \(Int(thisMonthHIITTotalTime))")
                            .font(Font.custom("SF Pro", size: 14))
                            .font(.title.bold())
                        //                                    .frame(maxWidth: .infinity, alignment:.trailing)
                            .foregroundColor(.orange)
                    }
                }
                .onAppear {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMMM"
                    monthName = formatter.string(from: today)
                    if let previousMonthDate = calendar.date(byAdding: .month, value: -1, to: today) {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MMMM"
                        previousMonthName = formatter.string(from: previousMonthDate)
                    }
                }
                    Spacer()
            }
            
            ZStack {
                VStack {
                    if stravaViewModel.isLoading {
                        LoadingAnimationView()
                    } else if stravaViewModel.activities.isEmpty {
                        Text("⚠️ No Activities Found")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ZStack {
                            Chart {
                                ForEach(lastMonthHIITData) { item in
                                    LineMark(
                                        x: .value("Day", item.category),
                                        y: .value("Value", item.value)
                                    )
                                    .interpolationMethod(.catmullRom)
                                    .foregroundStyle(Color(hex: "D0C7C0"))
                                    
                                    AreaMark(
                                        x: .value("Day", item.category),
                                        y: .value("Value", item.value)
                                    )
                                    .interpolationMethod(.catmullRom)
                                    .foregroundStyle(
                                        .linearGradient(
                                            Gradient(stops: [
                                                .init(color: Color(hex: "D0C7C0").opacity(0.6), location: 0),
                                                .init(color: Color(hex: "D0C7C0").opacity(0.0), location: 0.5)
                                            ]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                }
                            }
                            .chartYScale(domain: 0...maxYValue)
                            .chartXAxis(.hidden)
//                            .chartYAxis(.hidden)
                            .chartPlotStyle { plotArea in
                                plotArea.background(.clear)
                            }
                            .chartOverlay { proxy in
                                GeometryReader { geo in
                                    if let last = lastMonthHIITData.last,
                                       let x = proxy.position(forX: last.category),
                                       let y = proxy.position(forY: last.value) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.gray.opacity(0.4))
                                                .frame(width: 24, height: 24)
                                                .blur(radius: 8)
                                            Circle()
                                                .fill(Color.gray)
                                                .frame(width: 12, height: 12)
                                                .shadow(color: Color.gray.opacity(0.6), radius: 6, x: 0, y: 0)
                                        }
                                        .position(x: x, y: y - 1)
                                    }
                                }
                            }
                            .frame(height: 150)
                            
                            Chart {
                                ForEach(thisMonthHIITData) { item in
                                    LineMark(
                                        x: .value("Day", item.category),
                                        y: .value("Value", item.value)
                                    )
                                    .interpolationMethod(.catmullRom)
                                    .foregroundStyle(Color(hex: "FC5200"))
                                    
                                    AreaMark(
                                        x: .value("Day", item.category),
                                        y: .value("Value", item.value)
                                    )
                                    .interpolationMethod(.catmullRom)
                                    .foregroundStyle(
                                        .linearGradient(
                                            Gradient(stops: [
                                                .init(color: Color(hex: "FC5200").opacity(0.6), location: 0),
                                                .init(color: Color(hex: "FC5200").opacity(0.0), location: 0.5)
                                            ]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                }
                            }
                            .chartYScale(domain: 0...maxYValue)
                            .chartXAxis(.hidden)
//                            .chartYAxis(.hidden)
                            .chartPlotStyle { plotArea in
                                plotArea.background(.clear)
                            }
                            .chartOverlay { proxy in
                                GeometryReader { geo in
                                    if let last = thisMonthHIITData.last,
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
                                                .shadow(color: Color.orange.opacity(0.6), radius: 6, x: 0, y: 0)
                                        }
                                        .position(x: x, y: y - 1)
                                    }
                                }
                            }
                            .frame(height: 150)
                        }
                        
                        
                        HStack(spacing: 10) {
                            Button(action: {
                                animateData()
                            }) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.title) // Makes it bigger
                                    .foregroundColor(.orange.opacity(0.3))
                            }
                            .padding(.top)
                            .offset(x:10,y:-10)
                            Spacer()
                        }
                    }
                }
                .onAppear {
                    stravaViewModel.fetchActivities()
                }
            }
            .offset(y: 50)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))
//            .onAppear {
//                animateData()
//            }
            .onChange(of: stravaViewModel.activities) {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd"
   

                
                for activity in stravaViewModel.activities {
                    lastFour = String(activity.name?.suffix(4) ?? "")
                    
                    guard let startDate = activity.startDate else { continue }
                    let formattedDate = formatter.string(from: startDate)
                    let activityMonth = formattedDate.prefix(2)
                    let thisMonth = formatter.string(from: today).prefix(2)
                    let lastMonth = formatter.string(from: calendar.date(byAdding: .month, value: -1, to: today) ?? today).prefix(2)
                    
                    let movingTime = activity.movingTime ?? 0.0
                    
                    if lastFour == "HIIT" {
                        if thisMonth == activityMonth {

                            thisMonthHIITTotalTime += Double(movingTime)
                            thisMonthHIITActivities.append(ChartData(category: formattedDate, value: thisMonthHIITTotalTime))
                        } else if lastMonth == activityMonth {
                            print(formattedDate,movingTime)

                            lastMonthHIITTotalTime += Double(movingTime)
                            lastMonthHIITActivities.append(ChartData(category: formattedDate, value: lastMonthHIITTotalTime))
                        }
                    }
                }

                animateData()
            }
        }
    }

    func interpolatedY(atX xValue: Double, in data: [ChartData]) -> Double? {
        let indexBefore = Int(floor(xValue))
        let indexAfter = Int(ceil(xValue))
        guard indexBefore >= 0, indexAfter < data.count else { return nil }
        let y1 = data[indexBefore].value
        let y2 = data[indexAfter].value
        let ratio = xValue - Double(indexBefore)
        return y1 + ratio * (y2 - y1)
    }

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
