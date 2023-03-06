//
//  File.swift
//  
//
//  Created by Nunzio Ricci on 01/02/23.
//

protocol AIRequest: Encodable {
    associatedtype Response: AIResponse
    static var path: String { get }
    static var method: String { get }
}

protocol AIResponse: Decodable {}
