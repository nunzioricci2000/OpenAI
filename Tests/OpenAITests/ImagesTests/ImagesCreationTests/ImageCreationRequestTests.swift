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
    
    func testSize() throws {
        var request = try ImageCreationRequest(description: "A green dog", size: .small)
        var data = try encoder.encode(request)
        var dict = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        var size = dict["size"] as! String
        XCTAssertEqual(size, "256x256")
        request = try ImageCreationRequest(description: "A green dog", size: .medium)
        data = try encoder.encode(request)
        dict = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        size = dict["size"] as! String
        XCTAssertEqual(size, "512x512")
        request = try ImageCreationRequest(description: "A green dog", size: .big)
        data = try encoder.encode(request)
        dict = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        size = dict["size"] as! String
        XCTAssertEqual(size, "1024x1024")
    }
    
    func testFormat() throws {
        var request = try ImageCreationRequest(description: "A green dog", format: .url)
        var data = try encoder.encode(request)
        var dict = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        var format = dict["response_format"] as! String
        XCTAssertEqual(format, "url")
        request = try ImageCreationRequest(description: "A green dog", format: .b64)
        data = try encoder.encode(request)
        dict = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        format = dict["response_format"] as! String
        XCTAssertEqual(format, "b64_json")
    }
}
