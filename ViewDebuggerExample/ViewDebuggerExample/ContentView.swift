//
//  ContentView.swift
//  ViewDebuggerExample
//
//  Created by Christopher White on 21/11/2022.
//

import SwiftUI
import SwiftUIViewDebugger

struct ContentView: View {
    var body: some View {
        DebuggableContainer {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
