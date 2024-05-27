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
    @EnvironmentObject var preloadedData: PreloadedData
    @State private var statistics: (average: Double?, median: Double?, variance: Double?, standardDeviation: Double?, mode: Double?, range: Double?, min: Double?, max: Double?, q1: Double?, q3: Double?, iqr: Double?, count: Int, sum: Double, outliers: [Double]) = (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 0, [])
    @State private var isLoading = true

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading statistics for \(clubType.rawValue.capitalized)...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                VStack(alignment: .leading, spacing: 20) {
                    if let average = statistics.average {
                        Text("Average Distance: \(String(format: "%.2f", average)) yds")
                    }
                    if let median = statistics.median {
                        Text("Median Distance: \(String(format: "%.2f", median)) yds")
                    }
                    if let variance = statistics.variance {
                        Text("Variance: \(String(format: "%.2f", variance))")
                    }
                    if let standardDeviation = statistics.standardDeviation {
                        Text("Standard Deviation: \(String(format: "%.2f", standardDeviation))")
                    }
                    if let mode = statistics.mode {
                        Text("Mode: \(String(format: "%.2f", mode)) yds")
                    }
                    if let range = statistics.range {
                        Text("Range: \(String(format: "%.2f", range)) yds")
                    }
                    if let min = statistics.min {
                        Text("Min Distance: \(String(format: "%.2f", min)) yds")
                    }
                    if let max = statistics.max {
                        Text("Max Distance: \(String(format: "%.2f", max)) yds")
                    }
                    if let q1 = statistics.q1 {
                        Text("Q1 (25th percentile): \(String(format: "%.2f", q1)) yds")
                    }
                    if let q3 = statistics.q3 {
                        Text("Q3 (75th percentile): \(String(format: "%.2f", q3)) yds")
                    }
                    if let iqr = statistics.iqr {
                        Text("Interquartile Range (IQR): \(String(format: "%.2f", iqr)) yds")
                    }
                    Text("Count: \(statistics.count)")
                    Text("Sum of Distances: \(String(format: "%.2f", statistics.sum)) yds")
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
            calculateStatistics()
        }
    }

    private func calculateStatistics() {
        DispatchQueue.global(qos: .userInitiated).async {
            let start = DispatchTime.now()
            let stats = preloadedData.calculateStatistics(for: clubType)

            let end = DispatchTime.now()
            let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
            let timeInterval = Double(nanoTime) / 1_000_000_000
            print("***Time to calculate statistics: \(timeInterval) seconds")

            DispatchQueue.main.async {
                self.statistics = stats
                self.isLoading = false
            }
        }
    }
}

#Preview {
    ClubDetailView(clubType: .dr)
        .environmentObject(PreloadedData()) // Ensure to provide PreloadedData here for preview as well
}
