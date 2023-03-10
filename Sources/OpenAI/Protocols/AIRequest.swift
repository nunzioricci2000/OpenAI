//
//  AIRequest.swift
//  
//
//  Created by Nunzio Ricci on 07/03/23.
//

import Foundation

protocol AIRequest: Encodable {
    associatedtype Response: AIResponse
    
    func urlRequest(for url: URL) throws -> URLRequest
}
