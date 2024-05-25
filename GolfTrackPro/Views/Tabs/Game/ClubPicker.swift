//
//  ClubPicker.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/25/24.
//

import SwiftUI

struct ClubPicker: View {
    @Binding var selectedClub: Club?
    let onClubSelected: () -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                Picker("Select Club", selection: $selectedClub) {
                    Text("Select Club").tag(Club?.none)
                    ForEach(allClubs, id: \.self) { club in
                        Text(club.type.rawValue.capitalized).tag(Club?.some(club))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding()
                Button("Done") {
                    onClubSelected()
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
            }
            .navigationTitle("Select Club")
        }
    }
}
