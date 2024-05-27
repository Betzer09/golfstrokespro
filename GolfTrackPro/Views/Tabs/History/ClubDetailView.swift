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
                        HStack {
                            Text("Average Distance: \(String(format: "%.2f", average)) yds")
                            Spacer()
                            infoIcon("The average distance is like the middle point of all the swings. If you add up all the distances and divide by the number of swings, you get the average.")
                        }
                    }
                    if let median = statistics.median {
                        HStack {
                            Text("Median Distance: \(String(format: "%.2f", median)) yds")
                            Spacer()
                            infoIcon("The median distance is the middle value when all the distances are arranged in order. Half the swings are shorter, and half are longer.")
                        }
                    }
                    if let variance = statistics.variance {
                        HStack {
                            Text("Variance: \(String(format: "%.2f", variance))")
                            Spacer()
                            infoIcon("Variance shows how spread out the distances are. A small variance means the distances are close to the average, and a large variance means they are spread out.")
                        }
                    }
                    if let standardDeviation = statistics.standardDeviation {
                        HStack {
                            Text("Standard Deviation: \(String(format: "%.2f", standardDeviation))")
                            Spacer()
                            infoIcon("Standard deviation tells you how much the distances vary from the average. It's like the average amount by which each swing is different from the average swing.")
                        }
                    }
                    if let mode = statistics.mode {
                        HStack {
                            Text("Mode: \(String(format: "%.2f", mode)) yds")
                            Spacer()
                            infoIcon("The mode is the distance that happens most often. It's the most common swing distance.")
                        }
                    }
                    if let range = statistics.range {
                        HStack {
                            Text("Range: \(String(format: "%.2f", range)) yds")
                            Spacer()
                            infoIcon("The range is the difference between the longest and shortest swings. It shows how spread out the swings are.")
                        }
                    }
                    if let min = statistics.min {
                        HStack {
                            Text("Min Distance: \(String(format: "%.2f", min)) yds")
                            Spacer()
                            infoIcon("The minimum distance is the shortest swing.")
                        }
                    }
                    if let max = statistics.max {
                        HStack {
                            Text("Max Distance: \(String(format: "%.2f", max)) yds")
                            Spacer()
                            infoIcon("The maximum distance is the longest swing.")
                        }
                    }
                    if let q1 = statistics.q1 {
                        HStack {
                            Text("Q1 (25th percentile): \(String(format: "%.2f", q1)) yds")
                            Spacer()
                            infoIcon("The 25th percentile is the distance below which 25% of the swings fall. It's like a quarter of the swings are shorter than this distance.")
                        }
                    }
                    if let q3 = statistics.q3 {
                        HStack {
                            Text("Q3 (75th percentile): \(String(format: "%.2f", q3)) yds")
                            Spacer()
                            infoIcon("The 75th percentile is the distance below which 75% of the swings fall. It's like three quarters of the swings are shorter than this distance.")
                        }
                    }
                    if let iqr = statistics.iqr {
                        HStack {
                            Text("Interquartile Range (IQR): \(String(format: "%.2f", iqr)) yds")
                            Spacer()
                            infoIcon("The interquartile range (IQR) is the difference between the 75th percentile and the 25th percentile. It shows how spread out the middle 50% of swings are.")
                        }
                    }
                    HStack {
                        Text("Count: \(statistics.count)")
                        Spacer()
                        infoIcon("The count is the total number of swings.")
                    }
                    HStack {
                        Text("Sum of Distances: \(String(format: "%.2f", statistics.sum)) yds")
                        Spacer()
                        infoIcon("The sum of distances is the total distance of all swings added together.")
                    }
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

    private func infoIcon(_ explanation: String) -> some View {
        Button(action: {
            showExplanation = Explanation(message: explanation)
        }) {
            Image(systemName: "info.circle")
                .foregroundColor(.blue)
        }
    }
}

#Preview {
    ClubDetailView(clubType: .dr)
        .environmentObject(PreloadedData()) // Ensure to provide PreloadedData here for preview as well
}

struct Explanation: Identifiable {
    let id = UUID()
    let message: String
}
