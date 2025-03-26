//
//  Blob1Graphic.swift
//  DesignCodeUniversal
//
//  Created by Meng To on 2021-04-08.
//

import SwiftUI
import RiveRuntime

struct Blob1Graphic: View {
    @State var appear = false
    @Binding var selection: Int
    @State var active = true
    @State private var starryBG = RiveViewModel(fileName: "starry_starry_night")
    var body: some View {
        ZStack {
           
            starryBG.view()
                .scaleEffect(4)
                .onAppear {
                    starryBG.play()
                }
        }
        .opacity(active ? 1 : 0)
        .onAppear(perform: {
            update()
        })
        .onChange(of: selection, perform: { value in
            update()
        })
    }
    
    func update() {
        if selection == 1 {
            withAnimation {
                active = true
            }
            withAnimation(.easeOut(duration: 10)) {
                appear = true
            }
        } else {
            withAnimation {
                active = false
                appear = false
            }
        }
    }
}

struct Blob1Graphic_Previews: PreviewProvider {
    static var previews: some View {
        Blob1Graphic(selection: .constant(1))
    }
}
