//
//  DestinationView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/20/24.
//

import SwiftUI

struct DetailView: View {
    let hole: Int
    @Binding var swings: [Swing]


    var body: some View {
        VStack {
            Text("Hole \(hole)")
            Text("Score: \(swings.count)")

            List($swings) { $swing in
                HStack {
                    Text("Swing at \(swing.timestamp, formatter: dateFormatter)")
                    Picker("", selection: $swing.club) {
                        Text("Select Club").tag(Club?.none)
                        ForEach(allClubs, id: \.self) { club in
                            Text(club.type.rawValue.capitalized).tag(Club?.some(club))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }

        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

#Preview {
    let swingData = [
        Swing(timestamp: Date()),
        Swing(timestamp: Date().addingTimeInterval(300)),
        Swing(timestamp: Date().addingTimeInterval(600)),
    ]
    return DetailView(hole: 0, swings: .constant(swingData))
}
