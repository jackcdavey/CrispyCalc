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
    @Published var equationElements: [String] = []

    private var currentOperation: Operation?
    private var isNewValue = true
    private var operand: Double = 0
    private var lastOperand: Double = 0
    private var isEqualsRepeated = false

    func receiveInput(_ input: String) {
        switch input {
        case "0"..."9", ".":
            handleNumberInput(input)
        case "+", "-", "×", "÷":
            handleOperationInput(Operation(rawValue: input)!)
        case "=":
            handleEqualsInput()
        case "C":
            clearAll()
        case "±":
            toggleSign()
        case "%":
            convertToPercentage()
        default:
            break
        }
    }

    private func handleNumberInput(_ number: String) {
        if isNewValue || isEqualsRepeated {
            if displayValue == "0" && number != "." {
                displayValue = number // Replace '0' with the first number
            } else {
                displayValue += number // Append number or decimal point
            }
            isNewValue = false
            isEqualsRepeated = false
        } else {
            if number == ".", displayValue.contains(".") { return }
            displayValue += number
        }
    }


    private func handleOperationInput(_ operation: Operation) {
        if !isNewValue {
            calculate()
        }
        operand = Double(displayValue) ?? 0
        currentOperation = operation
        displayValue += " \(operation.rawValue) "
        isNewValue = true
        isEqualsRepeated = false // Reset this flag whenever a new operation is inputted
    }

    private func handleEqualsInput() {
        if !isEqualsRepeated {
            lastOperand = Double(displayValue.split(separator: " ").last ?? "0") ?? 0
            calculate()
            pastEquation = displayValue + " ="
            displayValue = formatResult(operand)
            isEqualsRepeated = true
        } else {
            if let operation = currentOperation {
                let newResult = performOperation(operation, operand, lastOperand)
                pastEquation = "\(formatResult(operand)) \(operation.rawValue) \(formatResult(lastOperand)) ="
                operand = newResult
                displayValue = formatResult(newResult)
            }
        }
    }

    private func calculate() {
        guard let operation = currentOperation, let newOperand = Double(displayValue.split(separator: " ").last ?? "0") else { return }
        operand = performOperation(operation, operand, newOperand)
        equationElements.append(contentsOf: [String(describing: operation.rawValue), String(describing: newOperand)])
    }

    private func performOperation(_ operation: Operation, _ a: Double, _ b: Double) -> Double {
        switch operation {
        case .addition:
            return a + b
        case .subtraction:
            return a - b
        case .multiplication:
            return a * b
        case .division:
            return b != 0 ? a / b : Double.nan // Handle division by zero
        }
    }

    private func clearAll() {
        displayValue = "0"
        pastEquation = ""
        operand = 0
        lastOperand = 0
        currentOperation = nil
        isNewValue = true
        isEqualsRepeated = false
    }

    private func toggleSign() {
        guard let value = Double(displayValue) else { return }
        displayValue = formatResult(-value)
    }

    private func convertToPercentage() {
        guard let value = Double(displayValue) else { return }
        displayValue = formatResult(value / 100)
    }

    private func formatResult(_ result: Double) -> String {
        if result.isNaN {
            return "Error"
        }
        return result.truncatingRemainder(dividingBy: 1) == 0 ?
               String(format: "%.0f", result) : String(result)
    }

    enum Operation: String {
        case addition = "+"
        case subtraction = "-"
        case multiplication = "×"
        case division = "÷"
    }
}
