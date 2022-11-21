//
//  JSONView.swift
//  
//
//  Created by Christopher White on 21/11/2022.
//

import SwiftUI

public struct JSONView: View {
    private let rootArray: [JSON]?
    private let rootDictionary: JSON

    public init(_ array: [JSON]) {
        self.rootArray = array
        self.rootDictionary = JSON()
    }

    public init(_ dictionary: JSON) {
        self.rootArray = nil
        self.rootDictionary = dictionary
    }

    public init(data: Data) {
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            self.rootArray = jsonData as? [JSON]
            self.rootDictionary = jsonData as? JSON ?? JSON()
        } catch {
            self.rootArray = nil
            self.rootDictionary = JSON()
            print("JSONView error: \(error.localizedDescription)")
        }
    }

    public init(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            self.rootArray = jsonData as? [JSON]
            self.rootDictionary = jsonData as? JSON ?? JSON()
        } catch {
            self.rootArray = nil
            self.rootDictionary = JSON()
            print("JSONView error: \(error.localizedDescription)")
        }
    }

    public var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            JSONTreeView(rootArray ?? rootDictionary)
                .padding([.top, .bottom], 10)
                .padding(.trailing, 10)
        }
    }
}
