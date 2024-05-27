//
//  StatsView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/22/24.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    @Environment(\.modelContext) var modelContext
    @Query(filter: #Predicate<Swing> { $0.distance != nil }, sort: \Swing.timestamp) private var swings: [Swing]
    @State private var averageDistances: [(key: ClubType, value: Double)] = []
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Crunching the numbers...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    List {
                        ForEach(averageDistances, id: \.key) { clubType, averageDistance in
                            HStack {
                                Text(clubType.rawValue.capitalized)
                                Spacer()
                                Text("\(String(format: "%.2f", averageDistance)) yds")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Club Averages")
            .onAppear {
                logPerformance()
            }
        }
    }

    private func logPerformance() {
        let start = DispatchTime.now()

        DispatchQueue.global().async {
            let averages = calculateAverageDistances()

            let end = DispatchTime.now()
            let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
            let timeInterval = Double(nanoTime) / 1_000_000_000

            DispatchQueue.main.async {
                print("Time to calculate averages: \(timeInterval) seconds")
                self.averageDistances = averages
                self.isLoading = false
            }
        }
    }

    // Calculate average distances grouped by club type and sort by average distance
    private func calculateAverageDistances() -> [(key: ClubType, value: Double)] {
        let groupedByClub = Dictionary(grouping: swings) { $0.club?.type }

        var averages = [ClubType: Double]()
        for (clubType, swings) in groupedByClub {
            guard let clubType = clubType else { continue }
            let totalDistance = swings.compactMap { $0.distance }.reduce(0, +)
            let averageDistance = totalDistance / Double(swings.count)
            averages[clubType] = averageDistance
        }

        return averages.sorted { $0.value > $1.value }
    }
}

#Preview {
    StatsView()
}
