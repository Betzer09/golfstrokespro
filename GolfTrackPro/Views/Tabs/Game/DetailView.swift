//
//  DestinationView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/20/24.
//

import SwiftUI

struct DetailView: View {
    let hole: Int
    @Bindable var score: Score
    var isEditable: Bool

    var body: some View {
        VStack {
            Text("Hole \(hole)")
            Text("Score: \($score.swings.count)")

            List {
                ForEach($score.swings) { swing in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Swing at \(swing.wrappedValue.timestamp, formatter: dateFormatter)")
                        }
                        Spacer()
                        if isEditable {
                            Picker("", selection: swing.club) {
                                let text = swing.club.wrappedValue == nil ? "Select Club" : swing.wrappedValue.club!.type.rawValue.capitalized
                                Text(text).tag(Club?.none)
                                ForEach(allClubs, id: \.self) { club in
                                    Text(club.type.rawValue.capitalized).tag(Club?.some(club))
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        } else {
                            Text(swing.club.wrappedValue?.type.rawValue.capitalized ?? "No Club")
                                .foregroundColor(.gray)
                        }
                        if let distance = swing.distance.wrappedValue {
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
    DetailView(hole: 1, score: PreviewConstants.score, isEditable: true)
}
