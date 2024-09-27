//
//  ITextFormatterService.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 15.09.2024.
//

import Foundation

public protocol ITextFormatterService {
  
  /// Заменяет все символы точки `.` в строке на запятые `,`.
  /// - Parameter input: Исходная строка.
  /// - Returns: Строка с заменёнными точками на запятые.
  func replaceDotsWithCommas(in input: String) -> String
  
  /// Заменяет все символы запятой `,` в строке на точки `.`.
  /// - Parameter input: Исходная строка.
  /// - Returns: Строка с заменёнными запятыми на точки.
  func replaceCommasWithDots(in input: String) -> String
  
  /// Удаляет все пробельные символы из строки.
  /// - Parameter input: Исходная строка.
  /// - Returns: Строка без пробелов.
  func removeAllSpaces(from input: String) -> String
  
  /// Удаляет ведущие нули из строки. Если есть десятичная часть, удаляет конечные нули после разделителя `,`.
  /// - Parameter input: Исходная строка, представляющая число.
  /// - Returns: Строка без лишних нулей.
  func removeExtraZeros(from input: String) -> String
  
  /// Форматирует числовую строку, разделяя целую часть пробелами, а дробную часть отделяет запятой.
  /// - Parameter input: Исходная строка, представляющая число.
  /// - Returns: Отформатированная строка.
  func formatNumberString(_ input: String) -> String
  
  /// Форматирует число типа `Double` в строку с указанным количеством знаков после запятой.
  /// - Parameters:
  ///   - value: Число типа `Double`.
  ///   - decimalPlaces: Количество знаков после запятой.
  /// - Returns: Отформатированная строка.
  func formatDouble(_ value: Double, decimalPlaces: Int) -> String
  
  /// Определяет количество символов после запятой в строке.
  /// - Parameter string: Строка, в которой производится поиск запятой.
  /// - Returns: Количество символов после запятой или `nil`, если запятая не найдена.
  func countCharactersAfterComma(in string: String) -> Int?
  
  /// Возвращает подстроку после запятой.
  /// - Parameter string: Строка, в которой производится поиск запятой.
  /// - Returns: Подстрока после запятой или `nil`, если запятая не найдена.
  func getStringAfterComma(in string: String) -> String?
  
  /// Форматирует числовую строку, добавляя пробелы для разделения разрядов в целой части.
  /// Если строка содержит запятую, она разделяется на целую и дробную части.
  /// - Parameter input: Исходная строка числа.
  /// - Returns: Отформатированная строка.
  func formatNumberWithThousands(_ input: String) -> String
  
  /// Удаляет ведущий ноль, если в строке нет запятой.
  /// - Parameter string: Исходная строка.
  /// - Returns: Строка без ведущего нуля или исходная строка, если запятая присутствует или первый символ не равен нулю.
  func removeLeadingZeroIfNoComma(in string: String) -> String
  
  /// Заменяет всю строку на "0", если она содержит подстроку "00".
  /// - Parameter string: Исходная строка.
  /// - Returns: "0", если строка содержит "00", иначе исходная строка.
  func replaceDoubleZeroWithZero(in string: String) -> String
}
