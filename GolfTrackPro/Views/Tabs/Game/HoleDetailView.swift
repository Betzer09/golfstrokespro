//
//  DestinationView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/20/24.
//

import SwiftUI

struct HoleDetailView: View {
    let hole: Int
    @Bindable var score: Score
    var isEditable: Bool
    @State private var showDeleteAlert = false
    @State private var swingToDelete: Swing?

    var body: some View {
        VStack {
            Text("Hole \(hole)")
            Text("Score: \($score.swings.count)")

            List {
                ForEach(sortedSwingBindings()) { swing in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Swung \(swing.wrappedValue.timestamp, formatter: dateFormatter)")
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
                .if(isEditable) { list in
                    list.onDelete { indexSet in
                        if let index = indexSet.first {
                            swingToDelete = score.swings[index]
                            showDeleteAlert = true
                        }
                    }
                }
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Swing"),
                    message: Text("Are you sure you want to delete this swing?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let swing = swingToDelete {
                            if let index = score.swings.firstIndex(of: swing) {
                                score.swings.remove(at: index)
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    private func sortedSwingBindings() -> [Binding<Swing>] {
        let sortedSwings = score.swings.sorted { $0.timestamp < $1.timestamp }
        return sortedSwings.map { swing in
            let index = score.swings.firstIndex(of: swing)!
            return $score.swings[index]
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter
    }
}

#Preview {
    HoleDetailView(hole: 1, score: PreviewConstants.score, isEditable: true)
}

