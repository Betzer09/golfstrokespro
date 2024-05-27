//
//  HistoryDataPreloader.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/26/24.
//

import SwiftUI
import SwiftData

class PreloadedData: ObservableObject {
    @Published var allSwings: [Swing] = []
    @Published var averageDistances: [(key: ClubType, value: Double)] = []
    @Published var isLoading = true

    func loadAllSwings(modelContext: ModelContext) {
        DispatchQueue.global(qos: .userInitiated).async {
            let start = DispatchTime.now()
            let fetchRequest = FetchDescriptor<Swing>(
                predicate: #Predicate<Swing> { swing in
                    swing.distance != nil
                },
                sortBy: [SortDescriptor(\.timestamp)]
            )
            do {
                let swings = try modelContext.fetch(fetchRequest)

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
                print("***Time to fetch and process swings: \(timeInterval) seconds")

                DispatchQueue.main.async {
                    self.allSwings = swings
                    self.averageDistances = sortedAverages
                    self.isLoading = false
                }
            } catch {
                print("***Error fetching swings: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }

    func calculateStatistics(for clubType: ClubType) -> (average: Double?, median: Double?, variance: Double?, standardDeviation: Double?, mode: Double?, range: Double?, min: Double?, max: Double?, q1: Double?, q3: Double?, iqr: Double?, count: Int, sum: Double, outliers: [Double]) {
        let filteredSwings = allSwings.filter { $0.club?.type == clubType }
        let distances = filteredSwings.compactMap { $0.distance }

        guard !distances.isEmpty else {
            return (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 0, [])
        }

        let average = distances.reduce(0, +) / Double(distances.count)
        let median = calculateMedian(distances)
        let variance = calculateVariance(distances, mean: average)
        let standardDeviation = sqrt(variance)
        let mode = calculateMode(distances)
        let range = (distances.max() ?? 0) - (distances.min() ?? 0)
        let min = distances.min()
        let max = distances.max()
        let q1 = calculatePercentile(distances.sorted(), percentile: 25)
        let q3 = calculatePercentile(distances.sorted(), percentile: 75)
        let iqr = q3 - q1
        let count = distances.count
        let sum = distances.reduce(0, +)
        let outliers = findOutliers(distances)

        return (average, median, variance, standardDeviation, mode, range, min, max, q1, q3, iqr, count, sum, outliers)
    }

    private func calculateMedian(_ distances: [Double]) -> Double? {
        let sortedDistances = distances.sorted()
        let middleIndex = sortedDistances.count / 2
        if sortedDistances.count % 2 == 0 {
            return (sortedDistances[middleIndex - 1] + sortedDistances[middleIndex]) / 2.0
        } else {
            return sortedDistances[middleIndex]
        }
    }

    private func calculateVariance(_ distances: [Double], mean: Double) -> Double {
        return distances.reduce(0) { $0 + pow($1 - mean, 2) } / Double(distances.count)
    }

    private func calculateMode(_ distances: [Double]) -> Double? {
        let frequency = distances.reduce(into: [:]) { counts, distance in counts[distance, default: 0] += 1 }
        if let (mode, _) = frequency.max(by: { $0.value < $1.value }) {
            return mode
        }
        return nil
    }

    private func findOutliers(_ distances: [Double]) -> [Double] {
        let sortedDistances = distances.sorted()
        let q1 = calculatePercentile(sortedDistances, percentile: 25)
        let q3 = calculatePercentile(sortedDistances, percentile: 75)
        let iqr = q3 - q1
        let lowerBound = q1 - 1.5 * iqr
        let upperBound = q3 + 1.5 * iqr
        return sortedDistances.filter { $0 < lowerBound || $0 > upperBound }
    }

    private func calculatePercentile(_ sortedDistances: [Double], percentile: Double) -> Double {
        let index = (percentile / 100.0) * Double(sortedDistances.count - 1)
        let lower = Int(index)
        let upper = lower + 1
        let weight = index - Double(lower)
        if upper < sortedDistances.count {
            return sortedDistances[lower] * (1.0 - weight) + sortedDistances[upper] * weight
        } else {
            return sortedDistances[lower]
        }
    }
}
