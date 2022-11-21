//
//  JSONRow.swift
//  
//
//  Created by Christopher White on 21/11/2022.
//

import SwiftUI

public struct JSONRow: View {
    private let key: String
    private let rawValue: AnyHashable

    @State private var isOpen: Bool = false
    @State private var isRotate: Bool = false

    internal init(_ keyValue: (key: String, value: AnyHashable)) {
        self.init(key: keyValue.key, value: keyValue.value)
    }

    public init(key: String, value: AnyHashable) {
        self.key = key
        self.rawValue = value
    }

    @ViewBuilder private func specificView() -> some View {
        switch rawValue {
        case let array as [JSON]: // NSArray
            keyValueView(treeView: JSONTreeView(array, prefix: key))
        case let dictionary as JSON: // NSDictionary
            keyValueView(treeView: JSONTreeView(dictionary, prefix: key))
        case let number as NSNumber: // NSNumber
            leafView(number.stringValue)
        case let string as String: // NSString
            leafView(string)
        case is NSNull: // NSNull
            leafView("null")
        default:
            leafView(rawValue.debugDescription)
        }
    }

    public func copyValue() {
        switch rawValue {
        case let array as [JSON]:
            UIPasteboard.general.string = (array as JSONRepresentable).stringValue
        case let dictionary as JSON:
            UIPasteboard.general.string = (dictionary as JSONRepresentable).stringValue
        case let number as NSNumber:
            UIPasteboard.general.string = number.stringValue
        case let string as String:
            UIPasteboard.general.string = string
        default:
            UIPasteboard.general.string = nil
        }
    }

    public var body: some View {
        specificView().padding(.leading, 10).contextMenu {
            Button(action: copyValue) {
                Text("Copy Value")
            }
        }
    }

    private func leafView(_ stringValue: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .center) {
                Text(key)
                Spacer()
            }

            Text(stringValue.prefix(60))
                .lineSpacing(0)
                .foregroundColor(Color.gray)
        }
        .padding(.vertical, 5)
        .padding(.trailing, 10)
    }

    private func toggle() {
        isOpen.toggle()
        withAnimation(.linear(duration: 0.1)) {
            self.isRotate.toggle()
        }
    }

    private func keyValueView(treeView valueView: JSONTreeView) -> some View {
        VStack(alignment: .leading) {
            Button(action: toggle) {
                HStack(alignment: .center) {
                    Image(systemName: "arrowtriangle.right.fill")
                        .resizable()
                        .frame(width: 10, height: 10, alignment: .center)
                        .foregroundColor(Color.gray)
                        .rotationEffect(Angle(degrees: isRotate ? 90 : 0))

                    Text(key)
                    Spacer()
                }
            }

            if isOpen {
                Divider()
                valueView
            }
        }
    }
}
