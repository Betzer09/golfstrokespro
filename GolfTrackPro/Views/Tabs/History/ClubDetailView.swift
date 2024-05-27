//
//  ClubDetailView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/26/24.
//

import SwiftUI
import SwiftData

struct ClubDetailView: View {
    let clubType: ClubType
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var preloadedData: HistoryDataPreloader
    @State private var statistics: (average: Double?, median: Double?, variance: Double?, standardDeviation: Double?, mode: Double?, range: Double?, min: Double?, max: Double?, q1: Double?, q3: Double?, iqr: Double?, count: Int, sum: Double, outliers: [Double]) = (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 0, [])
    @State private var isLoading = true
    @State private var showExplanation: Explanation?

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading statistics for \(clubType.rawValue.capitalized)...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                VStack(alignment: .leading, spacing: 20) {
                    if let average = statistics.average {
                        StatisticRow(label: "Average Distance", value: "\(String(format: "%.2f", average)) yds", explanation: "The average distance is like the middle point of all the swings. If you add up all the distances and divide by the number of swings, you get the average.", showExplanation: $showExplanation)
                    }
                    if let median = statistics.median {
                        StatisticRow(label: "Median Distance", value: "\(String(format: "%.2f", median)) yds", explanation: "The median distance is the middle value when all the distances are arranged in order. Half the swings are shorter, and half are longer.", showExplanation: $showExplanation)
                    }
                    if let variance = statistics.variance {
                        StatisticRow(label: "Variance", value: "\(String(format: "%.2f", variance))", explanation: "Variance shows how spread out the distances are. A small variance means the distances are close to the average, and a large variance means they are spread out.", showExplanation: $showExplanation)
                    }
                    if let standardDeviation = statistics.standardDeviation {
                        StatisticRow(label: "Standard Deviation", value: "\(String(format: "%.2f", standardDeviation))", explanation: "Standard deviation tells you how much the distances vary from the average. It's like the average amount by which each swing is different from the average swing.", showExplanation: $showExplanation)
                    }
                    if let mode = statistics.mode {
                        StatisticRow(label: "Mode", value: "\(String(format: "%.2f", mode)) yds", explanation: "The mode is the distance that happens most often. It's the most common swing distance.", showExplanation: $showExplanation)
                    }
                    if let range = statistics.range {
                        StatisticRow(label: "Range", value: "\(String(format: "%.2f", range)) yds", explanation: "The range is the difference between the longest and shortest swings. It shows how spread out the swings are.", showExplanation: $showExplanation)
                    }
                    if let min = statistics.min {
                        StatisticRow(label: "Min Distance", value: "\(String(format: "%.2f", min)) yds", explanation: "The minimum distance is the shortest swing.", showExplanation: $showExplanation)
                    }
                    if let max = statistics.max {
                        StatisticRow(label: "Max Distance", value: "\(String(format: "%.2f", max)) yds", explanation: "The maximum distance is the longest swing.", showExplanation: $showExplanation)
                    }
                    if let q1 = statistics.q1 {
                        StatisticRow(label: "Q1 (25th percentile)", value: "\(String(format: "%.2f", q1)) yds", explanation: "The 25th percentile is the distance below which 25% of the swings fall. It's like a quarter of the swings are shorter than this distance.", showExplanation: $showExplanation)
                    }
                    if let q3 = statistics.q3 {
                        StatisticRow(label: "Q3 (75th percentile)", value: "\(String(format: "%.2f", q3)) yds", explanation: "The 75th percentile is the distance below which 75% of the swings fall. It's like three quarters of the swings are shorter than this distance.", showExplanation: $showExplanation)
                    }
                    if let iqr = statistics.iqr {
                        StatisticRow(label: "Interquartile Range (IQR)", value: "\(String(format: "%.2f", iqr)) yds", explanation: "The interquartile range (IQR) is the difference between the 75th percentile and the 25th percentile. It shows how spread out the middle 50% of swings are.", showExplanation: $showExplanation)
                    }
                    StatisticRow(label: "Count", value: "\(statistics.count)", explanation: "The count is the total number of swings.", showExplanation: $showExplanation)
                    StatisticRow(label: "Sum of Distances", value: "\(String(format: "%.2f", statistics.sum)) yds", explanation: "The sum of distances is the total distance of all swings added together.", showExplanation: $showExplanation)
                    if !statistics.outliers.isEmpty {
                        Text("Outliers:")
                        ForEach(statistics.outliers, id: \.self) { outlier in
                            Text("\(String(format: "%.2f", outlier)) yds")
                        }
                    } else {
                        Text("No outliers found.")
                    }
                }
                .padding()
            }
        }
        .navigationTitle("\(clubType.rawValue.capitalized) Statistics")
        .onAppear {
            loadStatistics()
        }
        .alert(item: $showExplanation) { explanation in
            Alert(title: Text("Statistic Explanation"), message: Text(explanation.message), dismissButton: .default(Text("Got it!")))
        }
    }

    private func loadStatistics() {
        DispatchQueue.global(qos: .userInitiated).async {
            let start = DispatchTime.now()
            let stats = preloadedData.calculateStatistics(for: clubType)

            let end = DispatchTime.now()
            let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
            let timeInterval = Double(nanoTime) / 1_000_000_000
            print("***Time to load statistics: \(timeInterval) seconds")

            DispatchQueue.main.async {
                self.statistics = stats
                self.isLoading = false
            }
        }
    }
}

#Preview {
    ClubDetailView(clubType: .dr)
        .environmentObject(HistoryDataPreloader()) // Ensure to provide PreloadedData here for preview as well
}
