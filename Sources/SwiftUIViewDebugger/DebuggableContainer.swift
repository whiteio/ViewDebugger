//
//  DebuggableContainer.swift
//  
//
//  Created by Christopher White on 21/11/2022.
//

import SwiftUI

public struct DebuggableContainer<Content: View>: View {
    var content: Content
    @State var selectedSnapShotData: (AnyView?, Data?) = (nil,nil)

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        _VariadicView.Tree(DebuggableLayout(selectedSnapShotData: $selectedSnapShotData)) {
            content
        }
    }
}
