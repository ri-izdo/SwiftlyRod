//
//  Blob2Graphic.swift
//  DesignCodeUniversal
//
//  Created by Meng To on 2021-04-08.
//

import SwiftUI
import RiveRuntime

struct Blob2Graphic: View {
    @State var appear = false
    @Binding var selection: Int
    @State var active = true
    @State private var desertBG = RiveViewModel(fileName: "parallax_desert")
    
    var body: some View {
        ZStack {
            desertBG.view()
                .scaleEffect(3.73)
                .offset(y:-15)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    desertBG.play()
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
        if selection == 2 {
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

struct Blob2Graphic_Previews: PreviewProvider {
    static var previews: some View {
        Blob2Graphic(selection: .constant(2))
    }
}
