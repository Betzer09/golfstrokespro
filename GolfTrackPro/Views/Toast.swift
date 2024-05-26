//
//  Toast.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/26/24.
//

import SwiftUI

struct Toast: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.subheadline)
            .padding()
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top, 50)
            .transition(.move(edge: .top).combined(with: .opacity))
            .animation(.easeInOut, value: 0)
    }
}


#Preview {
    Toast(message: "Hello, world! I'm a Toast message.")
}
