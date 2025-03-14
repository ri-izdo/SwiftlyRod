//
//  TabModel.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/13/25.
//

import SwiftUI
import RiveRuntime


struct TabButton: View {
    @Binding var selectedTab: Int
    let tab: Int
    let riveFile: String
    let stateMachine: String
    let text: String

    let animationBoolean: String = "active" // ✅ Boolean input name from Rive

    @State private var riveViewModel: RiveViewModel? = nil

    var body: some View {
        VStack(spacing: 4) {
            riveViewModel?.view()
                .frame(width: 36, height: 36)
                .offset(y: 5)

            Text(text)
                .font(.system(size: 10))
                .foregroundColor(.white)
        }
        .colorMultiply(selectedTab == tab ? .orange : .gray)
        .onTapGesture {
            selectedTab = tab

            // 🔄 Reset first before setting to true
            riveViewModel?.setInput(animationBoolean, value: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                riveViewModel?.setInput(animationBoolean, value: true) // ✅ Restart animation
                print("✅ Rive animation triggered: \(animationBoolean)")
            }

            // 🔄 Reset animation after playing
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                riveViewModel?.setInput(animationBoolean, value: false) // ✅ Reset state
                print("🔄 Rive animation reset: \(animationBoolean)")
            }
        }
        .onAppear {
            riveViewModel = RiveViewModel(fileName: riveFile, stateMachineName: stateMachine, autoPlay: false)

            // ✅ Debug: Print available Rive inputs
            if let stateMachine = riveViewModel?.riveModel?.stateMachine {
                print("✅ State Machine Found: \(stateMachine)")
                for input in stateMachine.inputs {
                    print("🎯 Available Rive Input: \(input.name) - Type: \(input.type)")
                }
            } else {
                print("❌ No state machine found!")
            }
        }
    }
}
