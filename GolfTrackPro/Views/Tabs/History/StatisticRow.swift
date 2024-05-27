//
//  StatisticRow.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/27/24.
//

import SwiftUI

struct Explanation: Identifiable {
    let id = UUID()
    let message: String
}

struct StatisticRow: View {
    let label: String
    let value: String
    let explanation: String
    @Binding var showExplanation: Explanation?

    var body: some View {
        HStack {
            Text("\(label): \(value)")
            Spacer()
            infoIcon(explanation)
        }
    }

    private func infoIcon(_ explanation: String) -> some View {
        Button(action: {
            showExplanation = Explanation(message: explanation)
        }) {
            Image(systemName: "info.circle")
                .foregroundColor(.blue)
        }
    }
}
