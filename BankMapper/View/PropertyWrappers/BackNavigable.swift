//
//  BackNavigable.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/21/25.
//

import SwiftUI

@propertyWrapper
struct BackNavigable<Content: View>: View {
    private var title: String
    private var dismissAction: (() -> Void)?
    private var content: Content

    // Wrapped value for embedding custom content
    init(title: String, dismissAction: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.dismissAction = dismissAction
        self.content = content()
    }

    var wrappedValue: some View {
        NavigationView {
            content
                .adaptivePadding(horizontal: 20, vertical: 20)
                .navigationBarTitle(title, displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismissAction?()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                            }
                        }
                    }
                }
        }
    }

    var body: some View {
        wrappedValue
    }
}
