//
//  DisplayView.swift
//  CrispyCalc
//
//  Created by Jack Davey on 12/18/23.
//

import SwiftUI

struct DisplayView: View {
    @Environment(\.colorScheme) var colorScheme
    var pastEquation: String
    var displayValue: String

    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            // Past Equation
            Text(pastEquation)
                .font(.caption)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .transition(.move(edge: .top))
                .animation(.easeInOut, value: pastEquation)

            // Main Display
            Text(displayValue)
                .font(.largeTitle)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .transition(.move(edge: .trailing))
                .animation(.easeInOut, value: displayValue)
        }
        .padding()
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
        .background(colorScheme == .dark ? Color.black : Color.white)
    }
}



struct DisplayView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DisplayView(pastEquation: "1 + 1", displayValue: "2")
                .preferredColorScheme(.light)
            DisplayView(pastEquation: "1 + 1", displayValue: "2")
                .preferredColorScheme(.dark)
        }
    }
}
