//
//  WalkingChartView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/14/25.
//

import SwiftUI
import Charts


extension Animation {
    static func ripple(index: Int) -> Animation {
        Animation.spring(dampingFraction: 0.5)
            .speed(2)
            .delay(0.03 * Double(index))
    }
}


// MARK: - Custom Transition
extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
}




// MARK: - Walking Data View
struct WalkingChartView: View {
    @State private var showDetail = true
    @State private var walk: Walk = ModelData().Walks[0]
    
//    var path: KeyPath<Hike.Observation, Range<Double>>
//    var color: Color {
//        switch path {
//        case \.distance:
//            return .gray
//        }
//    }
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    WalkGraph(walk: walk, path: \.distance)
                        .frame(width: 50, height: 30)
                        .offset(x:2)
                    
                    VStack(alignment: .leading) {
                        Text(walk.name)
                            .font(.headline)
                        Text(walk.distanceText)
                    }
                    .offset(x:2)
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            showDetail.toggle()
                        }
                    } label: {
                        Label("Graph", systemImage: "chevron.right.circle")
                            .labelStyle(.iconOnly)
                            .imageScale(.large)
                            .rotationEffect(.degrees(showDetail ? 90 : 0))
                            .scaleEffect(showDetail ? 1.5 : 1)
                            .padding()
                    }
                }

                if showDetail {
                    WalkDetail(walk: walk)
                        .transition(.moveAndFade)
                }
            }
            .scaleEffect(0.85)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.3))
    }
}

struct WalkDetail: View {
    let walk: Walk
    @State var dataToShow = \Walk.Observation.distance

    var buttons = [
        ("Distance", \Walk.Observation.distance),
        ("Heart Rate", \Walk.Observation.heartRate),
        ("Pace", \Walk.Observation.pace)
    ]

    var body: some View {
        VStack {
            WalkGraph(walk: walk, path: dataToShow)
                .frame(height: 200)

            HStack(spacing: 25) {
                ForEach(buttons, id: \.0) { value in
                    Button {
                        dataToShow = value.1
                    } label: {
                        Text(value.0)
                            .font(.system(size: 15))
                            .foregroundStyle(value.1 == dataToShow
                                ? .gray
                                : .accentColor)
                            .animation(nil)
                    }
                }
            }
        }
    }
}


struct WalkGraph: View {
    var walk: Walk
    var path: KeyPath<Walk.Observation, Range<Double>>

    var color: Color {
        switch path {
        case \.distance:
            return Color(hex:"#FC5200")
        case \.heartRate:
            return Color(hue: 0.5, saturation: 0.5, brightness: 0.6)
        case \.pace:
            return Color(hue: 0.7, saturation: 0.4, brightness: 0.7)
        default:
            return .black
        }
    }

    var body: some View {
        let data = walk.observations
        let overallRange = rangeOfRanges(data.lazy.map { $0[keyPath: path] })
        let maxMagnitude = data.map { magnitude(of: $0[keyPath: path]) }.max()!
        let heightRatio = 1 - CGFloat(maxMagnitude / magnitude(of: overallRange))

        return GeometryReader { proxy in
            HStack(alignment: .bottom, spacing: proxy.size.width / 120) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, observation in
                    GraphCapsule(
                        index: index,
                        color: color,
                        height: proxy.size.height,
                        range: observation[keyPath: path],
                        overallRange: overallRange
                    )
                    .animation(.ripple(index: index))
                }
                .offset(x: 0, y: proxy.size.height * heightRatio)
            }
        }
    }
}

func rangeOfRanges<C: Collection>(_ ranges: C) -> Range<Double>
    where C.Element == Range<Double> {
    guard !ranges.isEmpty else { return 0..<0 }
    let low = ranges.lazy.map { $0.lowerBound }.min()!
    let high = ranges.lazy.map { $0.upperBound }.max()!
    return low..<high
}

func magnitude(of range: Range<Double>) -> Double {
    range.upperBound - range.lowerBound
}
    
    
struct GraphCapsule: View, Equatable {
    var index: Int
    var color: Color
    var height: CGFloat
    var range: Range<Double>
    var overallRange: Range<Double>

    var heightRatio: CGFloat {
        max(CGFloat(magnitude(of: range) / magnitude(of: overallRange)), 0.15)
    }

    var offsetRatio: CGFloat {
        CGFloat((range.lowerBound - overallRange.lowerBound) / magnitude(of: overallRange))
    }

    var body: some View {
        Capsule()
            .fill(color)
            .frame(height: height * heightRatio)
            .offset(x: 0, y: height * -offsetRatio)
    }
}



struct Walk: Codable, Hashable, Identifiable {
    var id: Int
    var name: String
    var distance: Double
    var difficulty: Int
    var observations: [Observation]

    static var formatter = LengthFormatter()

    var distanceText: String {
        Walk.formatter
            .string(fromValue: distance, unit: .kilometer)
    }

    struct Observation: Codable, Hashable {
        var distanceFromStart: Double

        var distance: Range<Double>
        var pace: Range<Double>
        var heartRate: Range<Double>
    }
}

