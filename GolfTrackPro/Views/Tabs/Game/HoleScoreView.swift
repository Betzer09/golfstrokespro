//
//  HoleScoreView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/19/24.
//

import SwiftUI

struct HoleScoreView: View {
    let hole: Int
    @Bindable var score: Score
    @State private var showLockAlert = false
    var onSwingAdded: () -> Void

    var body: some View {
        HStack {
            Text("Hole \(hole)")
            Spacer()
            HoleLocationTrackingView(score: score, showLockAlert: $showLockAlert)
            HoleScoreAdjuster(hole: hole, score: score, showLockAlert: $showLockAlert, onSwingAdded: onSwingAdded)
        }
        .swipeActions {
            if score.isLocked {
                Button("Unlock") {
                    score.isLocked = false
                }.tint(.blue)
            } else {
                Button("Lock") {
                    score.isLocked = true
                }.tint(.red)
            }
        }
        .alert(isPresented: $showLockAlert) {
            Alert(
                title: Text("Hole Locked"),
                message: Text("This hole is locked. Swipe to unlock it before viewing details."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    HoleScoreView(hole: 0,
                  score: PreviewConstants.score, onSwingAdded: {})
}
