//
//  CalculatorViewModel.swift
//  CrispyCalc
//
//  Created by Jack Davey on 12/18/23.
//

import Foundation

class CalculatorViewModel: ObservableObject {
    @Published var displayValue = "0"

    private var currentOperation: Operation?
    private var currentValue: Double = 0
    private var isNewValue = true

    func receiveInput(_ input: String) {
        switch input {
        case "0"..."9", ".":
            appendNumber(input)
        case "+", "-", "×", "÷":
            setOperation(Operation(rawValue: input))
        case "=":
            performCalculation()
        case "C":
            clear()
        default:
            break
        }
    }

    private func appendNumber(_ number: String) {
        if isNewValue {
            displayValue = number != "." ? number : "0."
            isNewValue = false
        } else {
            if number == ".", displayValue.contains(".") { return }
            displayValue += number
        }
    }

    private func setOperation(_ operation: Operation?) {
        if currentOperation != nil {
            performCalculation()
        }

        currentValue = Double(displayValue) ?? 0
        isNewValue = true
        currentOperation = operation
    }

    private func performCalculation() {
        guard let operation = currentOperation,
              let newValue = Double(displayValue) else { return }

        switch operation {
        case .addition:
            currentValue += newValue
        case .subtraction:
            currentValue -= newValue
        case .multiplication:
            currentValue *= newValue
        case .division:
            if newValue != 0 { currentValue /= newValue }
        }

        displayValue = formatResult(currentValue)
        isNewValue = true
        currentOperation = nil
    }

    private func clear() {
        displayValue = "0"
        currentValue = 0
        isNewValue = true
        currentOperation = nil
    }
    
    private func formatResult(_ result: Double) -> String {
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", result)
        } else {
            return String(result)
        }
    }

    enum Operation: String {
        case addition = "+"
        case subtraction = "-"
        case multiplication = "×"
        case division = "÷"
    }
}
