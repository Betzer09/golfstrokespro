//
//  View+Extensions.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/24/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
