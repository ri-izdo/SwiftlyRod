//
//  GoalBarView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/20/25.
//

import SwiftUI
import RiveRuntime

struct GoalBarView: View {
    @State private var count: Int = 5
    @State private var floatCount: Float = 5.0
    @State private var loadingAnimation = RiveViewModel(fileName: "sea_level_bar_chart3", stateMachineName: "interactive")
    
    var body: some View {
        HStack {
            VStack {
                Text("Goals")
                    .font(Font.custom("SF Pro", size: 18))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .frame(height: 0.3)
                    .background(Color.white)
                    .offset(y: -15)
                HStack {
                    loadingAnimation.view()
                        .onAppear {
                            loadingAnimation.setInput("level", value: floatCount)
                        }
                    VStack {
                        HStack {
                            Button(action: {
                                count += 1
                                floatCount += 1.0
                                loadingAnimation.setInput("level", value: floatCount)
                                
                            }) {
                                Text("+")
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            
                            Button(action: {
                                if count > 0 {
                                    count -= 1
                                    floatCount -= 1.0
                                    loadingAnimation.setInput("level", value: floatCount)
                                }
                            }) {
                                Text("-")
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                
                            }
                        }
                        .padding()
                        
                        Text("Total Walks Goal: \(count)")
                            .font(Font.custom("SF Pro", size: 14))
                            .foregroundColor(.white)
                            .offset(y:10)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.3))
    }
}



//
//#Preview {
//    GoalBarView()
//}
