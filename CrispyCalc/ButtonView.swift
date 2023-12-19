//
//  ButtonView.swift
//  CrispyCalc
//
//  Created by Jack Davey on 12/18/23.
//

import SwiftUI

struct ButtonView: View {
    var label: String
    var action: () -> Void
    var width: CGFloat?

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.title)
                .frame(width: width ?? buttonWidth(), height: buttonHeight())
                .background(buttonColor())
                .foregroundColor(Color.white)
                .cornerRadius(buttonHeight() / 2)
        }
    }

    private func buttonWidth() -> CGFloat {
        // Return button width
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }

    private func buttonHeight() -> CGFloat {
        // Return button height
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }

    private func buttonColor() -> Color {
        // Change color based on button type
        if label == "÷" || label == "×" || label == "-" || label == "+" || label == "=" {
            return Color.orange
        }
        return Color.gray
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(label: "1", action: {})
    }
}
