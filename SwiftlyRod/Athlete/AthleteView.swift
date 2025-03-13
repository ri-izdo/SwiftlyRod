//
//  AthleteView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/7/25.
//

import SwiftUI
import StravaSwift


struct AthleteView: View {
    var token: OAuthToken?

    var body: some View {
        VStack {
            if let token = token {
                let token = token.athlete
                
                let firstname = token?.firstname ?? ""
                let lastname = token?.lastname ?? ""
                let id = token?.id ?? 0
                
                Text("Welcome, \(firstname) \(lastname)")
                    .font(.title)
                    .padding()
                Text("ID: \(id)")
                
                
            } else {
                Text("Loading athlete data...")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }
}
