//
//  LandingView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/22/24.
//

import SwiftUI

struct LandingView: View {
    @State private var isAnimating = false

    var body: some View {
        VStack {
            Spacer()

            Text("⛳️")
                .font(.system(size: 200))
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }

            Spacer()

            Text("Golf Track Pro")
                .font(.title)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}



#Preview {
    LandingView()
}
