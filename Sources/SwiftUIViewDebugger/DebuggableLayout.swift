//
//  DebuggableLayout.swift
//  
//
//  Created by Christopher White on 21/11/2022.
//

import SwiftUI

struct DebuggableLayout: _VariadicView_UnaryViewRoot {
    @Binding var selectedSnapShotData: (AnyView?, Data?)

    @ViewBuilder
    func body(children: _VariadicView.Children) -> some View {
        if let image = selectedSnapShotData.0, let data = selectedSnapShotData.1 {
            debugContent(snapshot: image, data: data)
        } else {
            childListContent(children: children)
        }
    }

    private func childListContent(children: _VariadicView.Children) -> some View {
        ForEach(children) { child in
            Button(action: {
                let hostedValue = SwiftUI._makeUIHostingController(AnyView(child)) as! UIHostingController<AnyView>
                let viewValue = hostedValue.view as! _UIHostingView<AnyView>
                let _ = viewValue._renderForTest(interval: 0.1)
                let snap = AnyView(child)
                var childString: Data? = nil

                let debugData = viewValue._viewDebugData()
                if let serialized = _ViewDebug.serializedData(debugData) {
                    childString = serialized
                }
                selectedSnapShotData = (Optional(snap), childString)
            }, label: {
                child
                    .border(.blue.opacity(0.5))
            })
        }
    }

    private func debugContent(snapshot: AnyView, data: Data) -> some View {
        ScrollView {
            snapshot
                .border(.blue)
            JSONView(data: data)
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    selectedSnapShotData = (nil, nil)
                }, label: {
                    Text("Cancel")
                })
            })
        })
    }
}
