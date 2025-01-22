//
//  AdaptivePadding.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/21/25.
//

import SwiftUI

struct AdaptivePadding: ViewModifier {
    var horizontal: CGFloat
    var vertical: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, horizontal)
            .padding(.vertical, vertical)
            .padding(.horizontal, UIScreen.main.bounds.width > 400 ? 20 : 10) // Dynamic adjustment
    }
}

extension View {
    func adaptivePadding(horizontal: CGFloat, vertical: CGFloat) -> some View {
        self.modifier(AdaptivePadding(horizontal: horizontal, vertical: vertical))
    }
}

