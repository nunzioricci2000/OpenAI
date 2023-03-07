//
//  ImageCreationRequestTests.swift
//  
//
//  Created by Nunzio Ricci on 07/03/23.
//

import XCTest
@testable import OpenAI

final class ImageCreationRequestTests: XCTestCase {
    let encoder = JSONEncoder()
    
    func testDescription() throws {
        let request = try ImageCreationRequest(description: "A green dog")
        let data = try encoder.encode(request)
        let dict = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let prompt = dict["prompt"] as! String
        XCTAssertEqual(prompt, "A green dog")
    }
    
    func testLongDescriptionError() throws {
        let description = Array(repeating: "A green dog", count: 1000).joined()
        XCTAssertThrowsError(try ImageCreationRequest(description: description))
    }
    
    func testQuantity() throws {
        let request = try ImageCreationRequest(description: "A green dog", quantity: 3)
        let data = try encoder.encode(request)
        let dict = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let quantity = dict["n"] as! Int
        XCTAssertEqual(quantity, 3)
    }
    
    func testInvalidQuantityError() throws {
        XCTAssertThrowsError(try ImageCreationRequest(description: "A green dog", quantity: 11))
        XCTAssertThrowsError(try ImageCreationRequest(description: "A green dog", quantity: 0))
    }
    
}
