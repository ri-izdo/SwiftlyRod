//
//  AuthError.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/7/25.
//

import SwiftUI

struct AuthError: Identifiable {
    let id = UUID() // Unique identifier for the alert
    let message: String
}
