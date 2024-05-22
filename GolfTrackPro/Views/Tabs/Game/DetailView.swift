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

            List {
                ForEach($swings) { $swing in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Swing at \(swing.timestamp, formatter: dateFormatter)")
                        }
                        Spacer()
                        Picker("", selection: $swing.club) {
                            Text("Select Club").tag(Club?.none)
                            ForEach(allClubs, id: \.self) { club in
                                Text(club.type.rawValue.capitalized).tag(Club?.some(club))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        if let distance = swing.distance {
                            Text("\(Int(distance)) yds")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
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
