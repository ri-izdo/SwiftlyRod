//
//  HistoricDataView.swift
//  FitnessApp
//
//  Created by Jason Dubon on 7/29/23.
//

import SwiftUI
import Charts

struct ChartsView: View {
    @StateObject var viewModel = ChartsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    switch viewModel.selectedChart {
                    case .oneWeek:
                        VStack {
                            ChartDataView(average: $viewModel.oneWeekAverage, total: $viewModel.oneWeekTotal)
                            
                            Chart {
                                ForEach(viewModel.oneWeekChartData) { data in
                                    BarMark(x: .value(data.date.formatted(), data.date, unit: .day), y: .value("Steps", data.count))
                                }
                            }
                        }
                    case .oneMonth:
                        VStack {
                            ChartDataView(average: $viewModel.oneMonthAverage, total: $viewModel.oneMonthTotal)
                            
                            Chart {
                                ForEach(viewModel.oneMonthChartData) { data in
                                    BarMark(x: .value(data.date.formatted(), data.date, unit: .day), y: .value("Steps", data.count))
                                }
                            }
                        }
                    case .threeMonth:
                        VStack {
                            ChartDataView(average: $viewModel.threeMonthAverage, total: $viewModel.threeMonthTotal)
                            
                            Chart {
                                ForEach(viewModel.threeMonthsChartData) { data in
                                    BarMark(x: .value(data.date.formatted(), data.date, unit: .day), y: .value("Steps", data.count))
                                }
                            }
                        }
                    case .yearToDate:
                        VStack {
                            ChartDataView(average: $viewModel.ytdAverage, total: $viewModel.ytdTotal)
                            
                            Chart {
                                ForEach(viewModel.ytdChartData) { data in
                                    BarMark(x: .value(data.date.formatted(), data.date, unit: .month), y: .value("Steps", data.count))
                                }
                            }
                        }
                    case .oneYear:
                        VStack {
                            ChartDataView(average: $viewModel.oneYearAverage, total: $viewModel.oneYearTotal)
                            
                            Chart {
                                ForEach(viewModel.oneYearChartData) { data in
                                    BarMark(x: .value(data.date.formatted(), data.date, unit: .month), y: .value("Steps", data.count))
                                }
                            }
                        }
                    }
                }
                .foregroundColor(.green)
                .frame(maxHeight: 450)
                .padding(.horizontal)
                
                HStack {
                    ForEach(ChartOptions.allCases, id:\.rawValue) { option in
                        Button(option.rawValue) {
                            withAnimation {
                                viewModel.selectedChart = option
                            }
                        }
                        .padding()
                        .foregroundColor(viewModel.selectedChart == option ? .white : .green)
                        .background(viewModel.selectedChart == option ? .green : .clear)
                        .cornerRadius(10)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//            .navigationTitle(FitnessTabs.charts.rawValue)
            .padding(.top)
            .alert("Oops", isPresented: $viewModel.showAlert) {
                Button(role: .cancel) {
                    viewModel.showAlert = false
                } label: {
                    Text("Ok")
                }
            } message: {
                Text("We ran into issues fetching some of your step data please make sure you have allowed access and try again.")
            }
        }
    }
}

//struct HistoricDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChartsView()
//    }
//}
