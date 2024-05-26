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

    var body: some View {
        NavigationLink(destination: HoleDetailView(hole: score.hole, score: score, isEditable: true)) {
            HStack {
                Text("Hole \(hole)")
                Spacer()
                HoleLocationTrackingView(score: score, showLockAlert: $showLockAlert)
                HoleScoreAdjuster(hole: hole, score: score, showLockAlert: $showLockAlert)
            }
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
                message: Text("This hole is locked. Swipe to unlock it before performing this action."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}


#Preview {
    HoleScoreView(hole: 0,
                  score: PreviewConstants.score)
}
