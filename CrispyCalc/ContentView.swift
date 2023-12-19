//
//  ContentView.swift
//  CrispyCalc
//
//  Created by Jack Davey on 12/18/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = CalculatorViewModel() // Use @StateObject here

    let buttons: [[String]] = [
            ["C", "±", "%", "÷"],
            ["7", "8", "9", "×"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "+"],
            ["0", ".", "="]
        ]

    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            // Display
            DisplayView(pastEquation: viewModel.pastEquation, displayValue: viewModel.displayValue)
            // Buttons
            ForEach(buttons.indices, id: \.self) { rowIndex in
                HStack(spacing: 12) {
                    ForEach(buttons[rowIndex], id: \.self) { button in
                        if button == "0" {
                            ButtonView(label: button, action: {
                                viewModel.receiveInput(button)
                            }, width: self.zeroButtonWidth()) // Provide the custom width
                        } else {
                            ButtonView(label: button, action: {
                                viewModel.receiveInput(button)
                            })
                        }
                    }
                }
            }
        }
        .padding(.bottom)
    }
    
    private func buttonWidth() -> CGFloat {
            // Return button width
            return (UIScreen.main.bounds.width - 5 * 12) / 4
        }

        private func zeroButtonWidth() -> CGFloat {
            // Return double width for the '0' button
            return buttonWidth() * 2 + 12
        }

        private func buttonHeight() -> CGFloat {
            // Return button height
            return buttonWidth()
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
