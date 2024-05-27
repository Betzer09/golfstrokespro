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
    @ObservedObject var preloadedData: PreloadedData

    var body: some View {
        NavigationView {
            VStack {
                if preloadedData.isLoading {
                    ProgressView("Crunching the numbers...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    List {
                        ForEach(preloadedData.averageDistances, id: \.key) { clubType, averageDistance in
                            NavigationLink(destination: ClubDetailView(clubType: clubType)
                                .environmentObject(preloadedData)) {
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
            }
            .navigationTitle("Club Averages")
        }
    }
}

#Preview {
    StatsView(preloadedData: PreloadedData())
}
