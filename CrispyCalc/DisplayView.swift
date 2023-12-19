//
//  DisplayView.swift
//  CrispyCalc
//
//  Created by Jack Davey on 12/18/23.
//

import SwiftUI

struct DisplayView: View {
    var displayValue: String
    @Environment(\.colorScheme) var colorScheme // Environment property for color scheme

    var body: some View {
        Text(displayValue)
            .font(.largeTitle)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            .background(colorScheme == .dark ? Color.black : Color.white) // Background color change
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // Text color change
//            .border(colorScheme == .dark ? Color.gray : Color.gray, width: 2)
    }
}

struct DisplayView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DisplayView(displayValue: "12345")
                .preferredColorScheme(.light)
            DisplayView(displayValue: "12345")
                .preferredColorScheme(.dark)
        }
    }
}
