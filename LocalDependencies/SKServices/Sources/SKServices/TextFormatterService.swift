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

public final class TextFormatterService: ITextFormatterService {
  public init() {}
  
  public func replaceDotsWithCommas(in input: String) -> String {
    return input.replacingOccurrences(of: ".", with: ",")
  }
  
  public func replaceCommasWithDots(in input: String) -> String {
    return input.replacingOccurrences(of: ",", with: ".")
  }
  
  public func removeAllSpaces(from input: String) -> String {
    return input.replacingOccurrences(of: " ", with: "")
  }
  
  public func removeExtraZeros(from input: String) -> String {
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
  
  public func formatNumberString(_ input: String) -> String {
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
  
  public func formatDouble(_ value: Double, decimalPlaces: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.decimalSeparator = ","
    formatter.groupingSeparator = " "
    formatter.minimumFractionDigits = decimalPlaces
    formatter.maximumFractionDigits = decimalPlaces
    return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
  }
  
  public func countCharactersAfterComma(in string: String) -> Int? {
    // Находим индекс запятой
    guard let commaIndex = string.firstIndex(of: ",") else {
      return nil // Если запятая не найдена, возвращаем nil
    }
    
    // Получаем индекс следующего символа после запятой
    let nextIndex = string.index(after: commaIndex)
    
    // Извлекаем подстроку после запятой
    let substringAfterComma = string[nextIndex...]
    
    // Возвращаем количество символов в подстроке
    return substringAfterComma.count
  }
}
