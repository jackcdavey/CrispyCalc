//
//  CalculatorViewModel.swift
//  CrispyCalc
//
//  Created by Jack Davey on 12/18/23.
//

import Foundation

class CalculatorViewModel: ObservableObject {
    @Published var displayValue = "0"
    @Published var pastEquation = ""

    private var currentOperation: Operation?
    private var lastOperation: Operation?
    private var currentValue: Double = 0
    private var lastValue: Double = 0
    private var isNewValue = true
    private var hasTappedEquals = false

    func receiveInput(_ input: String) {
        switch input {
        case "0"..."9", ".":
            if isNewValue || displayValue == "0" {
                displayValue = input
            } else {
                displayValue += input
            }
            isNewValue = false
        case "+", "-", "×", "÷":
            if let operation = Operation(rawValue: input) {
                if !isNewValue {
                    performCalculation()
                }
                currentOperation = operation
                currentValue = Double(displayValue) ?? 0
                displayValue += " \(input) "
                isNewValue = false
            }
        case "=":
            if !hasTappedEquals {
                pastEquation = displayValue
                performCalculation()
                hasTappedEquals = true
            } else {
                repeatLastOperation()
            }
        case "C":
            clearValues()
        case "±":
            toggleSign()
        case "%":
            convertToPercentage()
        default:
            break
        }
        if input != "=" {
            hasTappedEquals = false
        }
    }

    
    private func toggleSign() {
        guard let currentValue = Double(displayValue), currentValue != 0 else { return }
        displayValue = formatResult(-currentValue)
    }

    private func convertToPercentage() {
        if let currentValue = Double(displayValue) {
            displayValue = formatResult(currentValue / 100)
        }
    }

    private func appendNumber(_ number: String) {
        if displayValue == "0" || isNewValue {
            if number != "0" && number != "." {
                displayValue = number
            }
            isNewValue = false
        } else {
            if number == ".", displayValue.contains(".") { return }
            displayValue += number
        }
    }


    private func setOperation(_ operation: Operation) {
        if currentOperation != nil && !isNewValue {
            // If we have an ongoing operation and the user has already entered a new number, perform the current operation
            performCalculation()
        }
        // Set the new operation
        currentOperation = operation
        // Remember the value before the next input comes in
        currentValue = Double(displayValue) ?? 0
        isNewValue = true
    }


    private func performCalculation() {
        if let operation = currentOperation,
           let newValue = extractLastNumber(from: displayValue) {
            lastValue = newValue
            calculate(operation: operation, with: newValue)
            displayValue = formatResult(currentValue)
            isNewValue = true
        }
    }

    private func calculate(operation: Operation, with operand: Double) {
        switch operation {
        case .addition:
            currentValue += operand
        case .subtraction:
            currentValue -= operand
        case .multiplication:
            currentValue *= operand
        case .division:
            if operand != 0 {
                currentValue /= operand
            } else {
                displayValue = "Error"
                clearValues()
                return
            }
        }

        // After performing the calculation, update the display value
//        displayValue = formatResult(currentValue)
//        currentValue = Double(displayValue) ?? 0
    }

    private func repeatLastOperation() {
        if let lastOperation = lastOperation {
            calculate(operation: lastOperation, with: lastValue)
            displayValue = formatResult(currentValue)
        }
    }
    
    private func extractLastNumber(from equation: String) -> Double? {
        // Split the equation by spaces to separate numbers and operators
        let components = equation.split(separator: " ").map(String.init)
        // Find the last component that can be converted to a Double
        for component in components.reversed() {
            if let number = Double(component) {
                return number
            }
        }
        return nil
    }



    private func receiveNonEqualInput(_ input: String) {
        // Handle other inputs like numbers and operations,
        // and reset the equals flag if necessary
        hasTappedEquals = false
        // ... handle other inputs ...
    }

    private func clearValues() {
        displayValue = "0"
        pastEquation = ""
        currentValue = 0
        lastValue = 0
        lastOperation = nil
        currentOperation = nil
        isNewValue = true
        hasTappedEquals = false
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
