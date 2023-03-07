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
        var request = try ImageCreationRequest(description: "A green dog")
        var data = try encoder.encode(request)
    }
}
