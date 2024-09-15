//
//  TextFormatterService.swift
//  SKServices
//
//  Created by Vitalii Sosin on 15.09.2024.
//

import Foundation
import SKAbstractions
import SKFoundation

// MARK: - TextFormatterService

public final class TextFormatterService {
  public init() {}
  
  /// Заменяет все символы точки `.` в строке на запятые `,`.
  /// - Parameter input: Исходная строка.
  /// - Returns: Строка с заменёнными точками на запятые.
  func replaceDotsWithCommas(in input: String) -> String {
    return input.replacingOccurrences(of: ".", with: ",")
  }
  
  /// Заменяет все символы запятой `,` в строке на точки `.`.
  /// - Parameter input: Исходная строка.
  /// - Returns: Строка с заменёнными запятыми на точки.
  func replaceCommasWithDots(in input: String) -> String {
    return input.replacingOccurrences(of: ",", with: ".")
  }
  
  /// Удаляет все пробельные символы из строки.
  /// - Parameter input: Исходная строка.
  /// - Returns: Строка без пробелов.
  func removeAllSpaces(from input: String) -> String {
    return input.replacingOccurrences(of: " ", with: "")
  }
  
  /// Удаляет ведущие нули из строки. Если есть десятичная часть, удаляет конечные нули после разделителя `,`.
  /// - Parameter input: Исходная строка, представляющая число.
  /// - Returns: Строка без лишних нулей.
  func removeExtraZeros(from input: String) -> String {
    var result = input
    
    // Удаление ведущих нулей, кроме случая "0,".
    while result.hasPrefix("0") && result.count > 1 && !result.hasPrefix("0,") {
      result.removeFirst()
    }
    
    // Проверка на наличие десятичной части.
    if let commaIndex = result.firstIndex(of: ",") {
      var fractional = String(result[result.index(after: commaIndex)...])
      
      // Удаление конечных нулей в дробной части.
      while fractional.hasSuffix("0") && fractional.count > 1 {
        fractional.removeLast()
      }
      
      // Если дробная часть стала равна "0", убрать запятую.
      if fractional == "0" {
        result = String(result[..<commaIndex])
      } else {
        result = String(result[..<commaIndex]) + "," + fractional
      }
    }
    
    return result
  }
  
  /// Форматирует числовую строку, разделяя целую часть пробелами, а дробную часть отделяет запятой.
  /// - Parameter input: Исходная строка, представляющая число.
  /// - Returns: Отформатированная строка.
  func formatNumberString(_ input: String) -> String {
    let components = input.split(separator: ",", maxSplits: 1, omittingEmptySubsequences: false)
    var integerPart = String(components.first ?? "")
    let fractionalPart = components.count > 1 ? String(components[1]) : ""
    
    // Разделение целой части на группы по три цифры с пробелами.
    var formattedInteger = ""
    let reversed = integerPart.reversed()
    for (index, char) in reversed.enumerated() {
      if index != 0 && index % 3 == 0 {
        formattedInteger.append(" ")
      }
      formattedInteger.append(char)
    }
    formattedInteger = String(formattedInteger.reversed())
    
    // Сборка окончательного результата.
    if fractionalPart.isEmpty {
      return formattedInteger
    } else {
      return "\(formattedInteger),\(fractionalPart)"
    }
  }
  
  /// Форматирует число типа `Double` в строку с указанным количеством знаков после запятой.
  /// - Parameters:
  ///   - value: Число типа `Double`.
  ///   - decimalPlaces: Количество знаков после запятой.
  /// - Returns: Отформатированная строка.
  func formatDouble(_ value: Double, decimalPlaces: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.decimalSeparator = ","
    formatter.groupingSeparator = " "
    formatter.minimumFractionDigits = decimalPlaces
    formatter.maximumFractionDigits = decimalPlaces
    return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
  }
}
