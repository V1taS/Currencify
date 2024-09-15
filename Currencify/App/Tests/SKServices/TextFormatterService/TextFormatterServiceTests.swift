//
//  RootScreenFeatureTests.swift
//  CurrencifyTests
//
//  Created by Vitalii Sosin on 06.01.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import XCTest
@testable import SKServices

final class TextFormatterServiceTests: XCTestCase {
  
  var service: TextFormatterService!
  
  override func setUp() {
    super.setUp()
    service = TextFormatterService()
  }
  
  override func tearDown() {
    service = nil
    super.tearDown()
  }
  
  // MARK: - replaceDotsWithCommas
  
  func testReplaceDotsWithCommas() {
    // Стандартные случаи
    XCTAssertEqual(service.replaceDotsWithCommas(in: "1.23.4"), "1,23,4")
    XCTAssertEqual(service.replaceDotsWithCommas(in: "...."), ",,,,")
    XCTAssertEqual(service.replaceDotsWithCommas(in: "No dots"), "No dots")
    XCTAssertEqual(service.replaceDotsWithCommas(in: ""), "")
    
    // Дополнительные случаи
    XCTAssertEqual(service.replaceDotsWithCommas(in: "123.456"), "123,456")
    XCTAssertEqual(service.replaceDotsWithCommas(in: ".StartWithDot"), ",StartWithDot")
    XCTAssertEqual(service.replaceDotsWithCommas(in: "EndWithDot."), "EndWithDot,")
    XCTAssertEqual(service.replaceDotsWithCommas(in: "Multiple...Dots"), "Multiple,,,Dots")
    XCTAssertEqual(service.replaceDotsWithCommas(in: "Mixed.dots.and.words."), "Mixed,dots,and,words,")
    XCTAssertEqual(service.replaceDotsWithCommas(in: "123.456.789.0"), "123,456,789,0")
    XCTAssertEqual(service.replaceDotsWithCommas(in: "....1234...."), ",,,,1234,,,,")
    XCTAssertEqual(service.replaceDotsWithCommas(in: "NoDotHere"), "NoDotHere")
    XCTAssertEqual(service.replaceDotsWithCommas(in: "Dot at the end."), "Dot at the end,")
    XCTAssertEqual(service.replaceDotsWithCommas(in: ".Dot at the start"), ",Dot at the start")
    XCTAssertEqual(service.replaceDotsWithCommas(in: "Consecutive..dots..here"), "Consecutive,,dots,,here")
    XCTAssertEqual(service.replaceDotsWithCommas(in: "123.45.67.89"), "123,45,67,89")
    XCTAssertEqual(service.replaceDotsWithCommas(in: "...."), ",,,,")
    XCTAssertEqual(service.replaceDotsWithCommas(in: "...."), ",,,,")
    XCTAssertEqual(service.replaceDotsWithCommas(in: "End with multiple dots...."), "End with multiple dots,,,,")
  }
  
  // MARK: - replaceCommasWithDots
  
  func testReplaceCommasWithDots() {
    // Стандартные случаи
    XCTAssertEqual(service.replaceCommasWithDots(in: "1,23,4"), "1.23.4")
    XCTAssertEqual(service.replaceCommasWithDots(in: ",,,,"), "....")
    XCTAssertEqual(service.replaceCommasWithDots(in: "No commas"), "No commas")
    XCTAssertEqual(service.replaceCommasWithDots(in: ""), "")
    
    // Дополнительные случаи
    XCTAssertEqual(service.replaceCommasWithDots(in: "123,456"), "123.456")
    XCTAssertEqual(service.replaceCommasWithDots(in: ",StartWithComma"), ".StartWithComma")
    XCTAssertEqual(service.replaceCommasWithDots(in: "EndWithComma,"), "EndWithComma.")
    XCTAssertEqual(service.replaceCommasWithDots(in: "Multiple,,,Commas"), "Multiple...Commas")
    XCTAssertEqual(service.replaceCommasWithDots(in: "Mixed,commas,and,words,"), "Mixed.commas.and.words.")
    XCTAssertEqual(service.replaceCommasWithDots(in: "123,456,789,0"), "123.456.789.0")
    XCTAssertEqual(service.replaceCommasWithDots(in: ",,,,1234,,"), "....1234..")
    XCTAssertEqual(service.replaceCommasWithDots(in: "NoCommaHere"), "NoCommaHere")
    XCTAssertEqual(service.replaceCommasWithDots(in: "Comma at the end,"), "Comma at the end.")
    XCTAssertEqual(service.replaceCommasWithDots(in: ",Comma at the start"), ".Comma at the start")
    XCTAssertEqual(service.replaceCommasWithDots(in: "Consecutive,,commas,,here"), "Consecutive..commas..here")
    XCTAssertEqual(service.replaceCommasWithDots(in: "123,45,67,89"), "123.45.67.89")
    XCTAssertEqual(service.replaceCommasWithDots(in: ",,,,,"), ".....")
    XCTAssertEqual(service.replaceCommasWithDots(in: ",,,,,,"), "......")
    XCTAssertEqual(service.replaceCommasWithDots(in: "End with multiple commas,,,,,"), "End with multiple commas.....")
  }
  
  // MARK: - removeAllSpaces
  
  func testRemoveAllSpaces() {
    // Стандартные случаи
    XCTAssertEqual(service.removeAllSpaces(from: "Hello World"), "HelloWorld")
    XCTAssertEqual(service.removeAllSpaces(from: "  Leading and trailing  "), "Leadingandtrailing")
    XCTAssertEqual(service.removeAllSpaces(from: "NoSpaces"), "NoSpaces")
    XCTAssertEqual(service.removeAllSpaces(from: ""), "")
    
    // Дополнительные случаи
    XCTAssertEqual(service.removeAllSpaces(from: "Multiple   Spaces"), "MultipleSpaces")
    XCTAssertEqual(service.removeAllSpaces(from: "  "), "")
    XCTAssertEqual(service.removeAllSpaces(from: "Space at the start "), "Spaceatthestart")
    XCTAssertEqual(service.removeAllSpaces(from: "Space at the end"), "Spaceattheend")
    XCTAssertEqual(service.removeAllSpaces(from: "In between spaces"), "Inbetweenspaces")
    XCTAssertEqual(service.removeAllSpaces(from: "Tabs\tand\nNewlines"), "Tabs\tand\nNewlines") // Не удаляются табы и переводы строк
    XCTAssertEqual(service.removeAllSpaces(from: "Mix of spaces and \t tabs"), "Mixofspacesand\ttabs")
    XCTAssertEqual(service.removeAllSpaces(from: "😊 Emoji with spaces 😊"), "😊Emojiwithspaces😊")
    XCTAssertEqual(service.removeAllSpaces(from: "123 456 789"), "123456789")
    XCTAssertEqual(service.removeAllSpaces(from: "Special characters !@# $%^ &*()"), "Specialcharacters!@#$%^&*()")
    XCTAssertEqual(service.removeAllSpaces(from: "Line1\nLine2 Line3"), "Line1\nLine2Line3")
    XCTAssertEqual(service.removeAllSpaces(from: "   LeadingSpaces"), "LeadingSpaces")
    XCTAssertEqual(service.removeAllSpaces(from: "TrailingSpaces   "), "TrailingSpaces")
    XCTAssertEqual(service.removeAllSpaces(from: "   Both   "), "Both")
  }
  
  // MARK: - removeExtraZeros
  
  func testRemoveExtraZeros() {
    // Стандартные случаи
    XCTAssertEqual(service.removeExtraZeros(from: "000123"), "123")
    XCTAssertEqual(service.removeExtraZeros(from: "0,123"), "0,123")
    XCTAssertEqual(service.removeExtraZeros(from: "0000"), "0")
    XCTAssertEqual(service.removeExtraZeros(from: "123,4500"), "123,45")
    XCTAssertEqual(service.removeExtraZeros(from: "123,000"), "123")
    XCTAssertEqual(service.removeExtraZeros(from: "0,1000"), "0,1")
    XCTAssertEqual(service.removeExtraZeros(from: "000123,4500"), "123,45")
    XCTAssertEqual(service.removeExtraZeros(from: "0000,0000"), "0")
    XCTAssertEqual(service.removeExtraZeros(from: "0,0"), "0")
    
    // Дополнительные случаи
    XCTAssertEqual(service.removeExtraZeros(from: "0012300"), "12300")
    XCTAssertEqual(service.removeExtraZeros(from: "0000,012300"), "0,0123")
    XCTAssertEqual(service.removeExtraZeros(from: "0000,0001"), "0,0001")
    XCTAssertEqual(service.removeExtraZeros(from: "1000,0000"), "1000")
    XCTAssertEqual(service.removeExtraZeros(from: "0100,0100"), "100,01")
    XCTAssertEqual(service.removeExtraZeros(from: "000"), "0")
    XCTAssertEqual(service.removeExtraZeros(from: "000,000"), "0")
    XCTAssertEqual(service.removeExtraZeros(from: "0,0000"), "0")
    XCTAssertEqual(service.removeExtraZeros(from: "1234500"), "1234500")
    XCTAssertEqual(service.removeExtraZeros(from: "1234500,0000"), "1234500")
    XCTAssertEqual(service.removeExtraZeros(from: "0001234500"), "1234500")
    XCTAssertEqual(service.removeExtraZeros(from: "0,10000"), "0,1")
    XCTAssertEqual(service.removeExtraZeros(from: "0000,10000"), "0,1")
    XCTAssertEqual(service.removeExtraZeros(from: "123,450000"), "123,45")
    XCTAssertEqual(service.removeExtraZeros(from: "000123,450000"), "123,45")
  }
  
  // MARK: - formatNumberString
  
  func testFormatNumberString() {
    // Стандартные случаи
    XCTAssertEqual(service.formatNumberString("1234567,89"), "1 234 567,89")
    XCTAssertEqual(service.formatNumberString("1000"), "1 000")
    XCTAssertEqual(service.formatNumberString("987654321"), "987 654 321")
    XCTAssertEqual(service.formatNumberString("1234,5"), "1 234,5")
    XCTAssertEqual(service.formatNumberString("0,001"), "0,001")
    XCTAssertEqual(service.formatNumberString(""), "")
    
    // Дополнительные случаи
    XCTAssertEqual(service.formatNumberString("12"), "12")
    XCTAssertEqual(service.formatNumberString("123"), "123")
    XCTAssertEqual(service.formatNumberString("12345"), "12 345")
    XCTAssertEqual(service.formatNumberString("123456"), "123 456")
    XCTAssertEqual(service.formatNumberString("1234567890"), "1 234 567 890")
    XCTAssertEqual(service.formatNumberString("1000000,00"), "1 000 000,00")
    XCTAssertEqual(service.formatNumberString("0"), "0")
    XCTAssertEqual(service.formatNumberString("0,0"), "0,0")
    XCTAssertEqual(service.formatNumberString("1000000000"), "1 000 000 000")
    XCTAssertEqual(service.formatNumberString("999999999,99"), "999 999 999,99")
    XCTAssertEqual(service.formatNumberString("1001,01"), "1 001,01")
    XCTAssertEqual(service.formatNumberString("1234567890123,456"), "1 234 567 890 123,456")
    XCTAssertEqual(service.formatNumberString("1,1"), "1,1")
    XCTAssertEqual(service.formatNumberString("10,10"), "10,10")
    XCTAssertEqual(service.formatNumberString("100,100"), "100,100")
  }
  
  // MARK: - formatDouble
  
  func testFormatDouble() {
    // Стандартные случаи
    XCTAssertEqual(service.formatDouble(1234.5678, decimalPlaces: 2), "1 234,57")
    XCTAssertEqual(service.formatDouble(1000.0, decimalPlaces: 0), "1 000")
    XCTAssertEqual(service.formatDouble(987654321.123456, decimalPlaces: 3), "987 654 321,123")
    XCTAssertEqual(service.formatDouble(0.001, decimalPlaces: 4), "0,0010")
    XCTAssertEqual(service.formatDouble(-1234.5, decimalPlaces: 1), "-1 234,5")
    XCTAssertEqual(service.formatDouble(0.0, decimalPlaces: 2), "0,00")
    
    // Дополнительные случаи
    XCTAssertEqual(service.formatDouble(123.456, decimalPlaces: 1), "123,5")
    XCTAssertEqual(service.formatDouble(123.451, decimalPlaces: 2), "123,45")
    XCTAssertEqual(service.formatDouble(9999999.9999, decimalPlaces: 3), "10 000 000,000")
    XCTAssertEqual(service.formatDouble(-0.0001, decimalPlaces: 4), "-0,0001")
    XCTAssertEqual(service.formatDouble(1000000.0, decimalPlaces: 0), "1 000 000")
    XCTAssertEqual(service.formatDouble(1000000.1234, decimalPlaces: 2), "1 000 000,12")
    XCTAssertEqual(service.formatDouble(0.9999, decimalPlaces: 3), "1,000")
    XCTAssertEqual(service.formatDouble(-999.999, decimalPlaces: 2), "-1 000,00")
    XCTAssertEqual(service.formatDouble(1234567890.123456, decimalPlaces: 5), "1 234 567 890,12346")
    XCTAssertEqual(service.formatDouble(0.0000, decimalPlaces: 4), "0,0000")
    XCTAssertEqual(service.formatDouble(-123456.789, decimalPlaces: 3), "-123 456,789")
    XCTAssertEqual(service.formatDouble(50.5, decimalPlaces: 0), "50")
    XCTAssertEqual(service.formatDouble(50.4, decimalPlaces: 0), "50")
    XCTAssertEqual(service.formatDouble(1234.999, decimalPlaces: 2), "1 235,00")
    XCTAssertEqual(service.formatDouble(-0.5555, decimalPlaces: 3), "-0,556")
  }
  
  // MARK: - countCharactersAfterComma
  
  func testCountCharactersAfterComma() {
    // Стандартные случаи
    XCTAssertEqual(service.countCharactersAfterComma(in: "123,456"), 3)
    XCTAssertEqual(service.countCharactersAfterComma(in: "1.23,45"), 2)
    XCTAssertEqual(service.countCharactersAfterComma(in: "123,4"), 1)
    XCTAssertEqual(service.countCharactersAfterComma(in: "123,"), 0)
    XCTAssertEqual(service.countCharactersAfterComma(in: ","), 0)
    XCTAssertEqual(service.countCharactersAfterComma(in: "123"), nil)
    XCTAssertEqual(service.countCharactersAfterComma(in: ""), nil)
    
    // Дополнительные случаи
    XCTAssertEqual(service.countCharactersAfterComma(in: "123,4567890"), 7)
    XCTAssertEqual(service.countCharactersAfterComma(in: "abc,defghijkl"), 9)
    XCTAssertEqual(service.countCharactersAfterComma(in: "NoCommaHere"), nil)
    XCTAssertEqual(service.countCharactersAfterComma(in: "StartsWithComma,"), 0)
  }
}
