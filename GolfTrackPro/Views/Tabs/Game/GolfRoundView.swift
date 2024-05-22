//
//  GolfRoundView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/19/24.
//
import SwiftUI

struct GolfRoundView: View {
    @State private var scores: [Score] = (1...18).map { Score(swings: [], hole: $0) }
    @State private var numberOfHoles: Int = 9

    var body: some View {
        NavigationView {
            VStack {
                Picker("Number of Holes", selection: $numberOfHoles) {
                    Text("9 Holes").tag(9)
                    Text("18 Holes").tag(18)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List(0..<numberOfHoles, id: \.self) { index in
                    NavigationLink(destination: DetailView(hole: scores[index].hole, swings: $scores[index].swings)) {
                        HoleScoreView(hole: scores[index].hole, swings: $scores[index].swings)
                    }
                }

                HStack {
                    Text("Total Score")
                    Spacer()
                    Text("\(totalScore())") 
                        .bold()
                }
                .padding()
            }
            .onChange(of: numberOfHoles) {
                updateScores(for: numberOfHoles)
            }
        }
    }

    private func updateScores(for holes: Int) {
        scores = (1...holes).map { Score(swings: [], hole: $0) }
    }

    func totalScore() -> Int {
        scores.reduce(0) { $0 + $1.swings.count }
    }
}

#Preview {
    GolfRoundView()
}


#Preview {
    GolfRoundView()
}
