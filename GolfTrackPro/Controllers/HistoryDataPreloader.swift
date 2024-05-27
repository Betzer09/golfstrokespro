//
//  HistoryDataPreloader.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/26/24.
//

import SwiftUI
import SwiftData

class PreloadedData: ObservableObject {
    @Published var averageDistances: [(key: ClubType, value: Double)] = []
    @Published var isLoading = true

    func loadAverageDistances(modelContext: ModelContext) {
        DispatchQueue.global().async {
            let start = DispatchTime.now()
            let fetchRequest = FetchDescriptor<Swing>(predicate: #Predicate { $0.distance != nil }, sortBy: [SortDescriptor(\.timestamp)])
            let swings: [Swing]
            do {
                swings = try modelContext.fetch(fetchRequest)
            } catch {
                print("***Error fetching swings: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }

            let groupedByClub = Dictionary(grouping: swings) { $0.club?.type }

            var averages = [ClubType: Double]()
            for (clubType, swings) in groupedByClub {
                guard let clubType = clubType else { continue }
                let totalDistance = swings.compactMap { $0.distance }.reduce(0, +)
                let averageDistance = totalDistance / Double(swings.count)
                averages[clubType] = averageDistance
            }

            let sortedAverages = averages.sorted { $0.value > $1.value }

            let end = DispatchTime.now()
            let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
            let timeInterval = Double(nanoTime) / 1_000_000_000

            print("***Time to calculate averages: \(timeInterval) seconds")

            DispatchQueue.main.async {
                self.averageDistances = sortedAverages
                self.isLoading = false
            }
        }
    }
}
