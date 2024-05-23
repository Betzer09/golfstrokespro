//
//  DestinationView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/20/24.
//

import SwiftUI

struct DetailView: View {
    let hole: Int
    var swings: [Swing]
    @State var selectedClub: Club?

    var body: some View {
        VStack {
            Text("Hole \(hole)")
            Text("Score: \(swings.count)")

            List {
                ForEach(swings) { swing in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Swing at \(swing.timestamp, formatter: dateFormatter)")
                        }
                        Spacer()
                        Picker("", selection: $selectedClub) {
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
    return DetailView(hole: PreviewConstants.score.hole,
                      swings: PreviewConstants.swingData, selectedClub: allClubs[0])
}
