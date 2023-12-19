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
    private var lastOperation: Operation?
    private var currentValue: Double = 0
    private var lastValue: Double = 0
    private var isNewValue = true
    private var hasTappedEquals = false
    
    func receiveInput(_ input: String) {
        switch input {
        case "0"..."9", ".":
            appendNumber(input)
        case "+", "-", "×", "÷":
            if let operation = Operation(rawValue: input) {
                setOperation(operation)
            }
        case "=":
            if hasTappedEquals {
                // If equals was already tapped, we repeat the last operation with the lastValue
                repeatLastOperation()
            } else {
                // If this is the first time equals is tapped after an input, we perform the current operation
                performCalculation()
                hasTappedEquals = true
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
        // If any input other than "=" is received, reset the equals flag
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
        guard let operation = currentOperation,
              let newValue = Double(displayValue) else { return }

        // Perform calculation with current value and new value
        calculate(operation: operation, with: newValue)

        // Save the result of this calculation as the starting point for any subsequent calculations
        currentValue = Double(displayValue) ?? 0

        // Save the new value as the last value in case "=" is pressed again
        if !hasTappedEquals {
            lastValue = newValue
        }

        // Update the display with the new current value
        displayValue = formatResult(currentValue)

        // Set state to indicate a new value entry is expected next
        isNewValue = true
        // Save the last operation in case "=" is pressed again
        lastOperation = currentOperation
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
        displayValue = formatResult(currentValue)
    }

    private func repeatLastOperation() {
        if let lastOperation = lastOperation {
            // Perform the last operation using the last value
            calculate(operation: lastOperation, with: lastValue)
            // Update displayValue with the new currentValue after repeating the operation
            displayValue = formatResult(currentValue)
        }
    }


    private func receiveNonEqualInput(_ input: String) {
        // Handle other inputs like numbers and operations,
        // and reset the equals flag if necessary
        hasTappedEquals = false
        // ... handle other inputs ...
    }

    private func clearValues() {
          displayValue = "0"
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
