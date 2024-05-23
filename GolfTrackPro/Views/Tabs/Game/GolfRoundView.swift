//
//  GolfRoundView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/19/24.
//
import SwiftUI
import SwiftData

struct GolfRoundView: View {
    @Environment(\.modelContext) var modelContext
//    @State private var scores: [Score] = []
    @Query(sort: \Score.hole, order: .forward) private var queryiedScores: [Score] = []
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

                List(0..<queryiedScores.count, id: \.self) { index in
                    NavigationLink(destination: DetailView(hole: queryiedScores[index].hole,
                                                           swings: queryiedScores[index].swings)) {
                        HoleScoreView(hole: queryiedScores[index].hole,
                                      score: queryiedScores[index])
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
            .onAppear(perform: loadScores)
            .onChange(of: numberOfHoles) {
                updateScores(for: numberOfHoles)
            }
        }
    }

    private func loadScores() {
        if queryiedScores.isEmpty {
            print("Creating a new game of scores.")
            let createdScores = (1...$numberOfHoles.wrappedValue).map { Score(hole: $0) }
            createdScores.forEach({ modelContext.insert($0) })
        } else {
            print("Loading already existing scores")
        }
    }

    private func updateScores(for holes: Int) {
//        scores = (1...holes).map { Score(hole: $0) }
    }

    func totalScore() -> Int {
        queryiedScores.reduce(0) { $0 + $1.swings.count }
    }
}

#Preview {
    GolfRoundView()
}


#Preview {
    GolfRoundView()
}
