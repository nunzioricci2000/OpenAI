//
//  ImageTests.swift
//  
//
//  Created by Nunzio Ricci on 05/02/23.
//

import XCTest
@testable import OpenAI

@available(macOS 13.0, *)
final class ImageTests: XCTestCase {
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    let openai = OpenAI(token: "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")
    
    func testRequestEncoding() throws {
        let request = try ImageRequest(description: "Salve")
        let data = try encoder.encode(request)
        let jsonString = String(data: data, encoding: .utf8)
        XCTAssertEqual(jsonString, "{\"prompt\":\"Salve\"}")
    }
    
    func testResponseDecoding() throws {
        let responseString = "{\"created\": 1678058194, \"data\": [{\"url\": \"https://...\"}]}"
        let responseData = responseString.data(using: .utf8)!
        let response = try decoder.decode(ImageResponse.self, from: responseData)
        XCTAssertEqual(response.created, 1678058194)
        XCTAssertEqual(response.data[0].url, "https://...")
    }
    
    func testPath() {
        let urlRequest = URLRequest(url: OpenAI.API_URL.appending(path: ImageRequest.path))
        XCTAssertEqual(urlRequest.url?.absoluteString, "https://api.openai.com/v1/images/generations")
    }
    
    func testPerformAction() async throws {
        let request = try ImageRequest(description: "A green dog")
        let response = try await openai.perform(request)
    }
}
