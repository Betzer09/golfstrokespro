//
//  HoleScoreView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/19/24.
//

import SwiftUI

struct HoleScoreView: View {
    let hole: Int
    @Binding var swings: [Swing]

    var body: some View {
        HStack {
            Text("Hole \(hole)")
            Spacer()
            Button(action: {
                if swings.count > 0 {
                    swings.removeLast()
                    print("Decreased score for hole \(hole) to \(swings.count)")

                }
            }) {
                Image(systemName: "minus.circle")
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.trailing, 8)

            Text("\(swings.count)")
                .frame(width: 40)
                .multilineTextAlignment(.center)

            Button(action: {
                swings.append(Swing())
                print("Increased score for hole \(hole) to \(swings.count)")
            }) {
                Image(systemName: "plus.circle")
                    .foregroundColor(.green)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.leading, 8)
        }
    }
}

#Preview {
    HoleScoreView(hole: 0, swings: .constant([Swing]()))
}
