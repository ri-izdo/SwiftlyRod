//
//  ActivityCellModel.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/12/25.
//

import SwiftUI
import StravaSwift
import RiveRuntime


struct ActivityCellModel: View {
    var activity: Activity
    var token: OAuthToken?
    
    let nameTextSize: Float = 18.0
    let activityNameFontSize: Float = 25.0
    let statTextTitleSize: Float = 10.0
    let statTextValuesize: Float = 14.0
    @State private var goalButton = RiveViewModel(fileName: "bell_animation")
    
    var body: some View {
        ZStack {
            BlurView(style: .dark)
            Color.gray.opacity(0.25)
            
            VStack {
                Spacer()
                header()
                Spacer()
                activityStats()
                Spacer()
            }
            .padding()
        }
    }
    
    /// Formats the activity date to show only the month name.
    func activityDate() -> some View {
        if let date = activity.startDate {
            return Text("\(date, style: .date)")
        } else {
            return Text("")
        }
    }
    
    func header() -> some View {
        let firstName = token?.athlete?.firstname ?? "Unknown"
        let lastName = token?.athlete?.lastname ?? ""
        let activityName = activity.name ?? "Unknown Activity"

        return HStack {
            VStack(alignment: .leading) {
                Text("\(firstName) \(lastName)")
                    .font(.system(size: CGFloat(nameTextSize)))
                activityDate()
                    .font(.system(size: CGFloat(statTextTitleSize)))
                Spacer()
                Text(activityName)
                    .font(.system(size: CGFloat(activityNameFontSize)))
                    .bold()
                Spacer()
            }
            Spacer()
        }
    }
    
    func activityStats() -> some View {
        let distance = feetToMiles(feet: activity.distance ?? 0.0)
        let movingTime = activity.movingTime ?? 0.0
        let distanceDisplay = String(format: "%.2f",distance)
        
        return HStack {
                VStack(alignment: .leading) {
                    Text("Distance")
                        .font(.system(size: CGFloat(statTextTitleSize)))
                    Text("\(distanceDisplay) mi")
                        .font(.system(size: CGFloat(statTextValuesize)))
                }
                VStack(alignment: .leading) {
                    Text("Duration")
                        .font(.system(size: CGFloat(statTextTitleSize)))
                    Text("\(formatTime(seconds: movingTime))")
                        .font(.system(size: CGFloat(statTextValuesize)))
                }
            Spacer()
            
            if Float(distance) >= 0.2 {
                VStack {
                    goalButton.view()
                        .onAppear() {
                            goalButton.play(animationName: "idleStroke")
                        }
                        .onTapGesture {
                            goalButton.play(animationName: "ClickToFill")
                        }
                }
                .offset(x: 100, y: -90)
            }
        }
    }
    
    func formatTime(seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        let seconds = Int(seconds) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func feetToMiles(feet: Double) -> Float {
        let value = feet / 5280
        return Float(String(format: "%.2f",value)) ?? 0.0
    }
}


struct BlurView: UIViewRepresentable {

    let style: UIBlurEffect.Style

    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }

    func updateUIView(_ uiView: UIView,
                      context: UIViewRepresentableContext<BlurView>) {

    }

}
