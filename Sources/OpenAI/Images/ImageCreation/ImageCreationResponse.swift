//
//  ImageCreationResponse.swift
//  
//
//  Created by Nunzio Ricci on 07/03/23.
//

import Foundation

/// This object contains required images from Dall•E
struct ImageCreationResponse: AIResponse {
    var created: Int
    var data: [ImageResult]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.created = try container.decode(Int.self, forKey: .created)
        self.data = try container.decode([ImageResult].self, forKey: .data)
    }
    
    enum CodingKeys: CodingKey {
        case created
        case data
    }
}

struct ImageResult: Decodable {
    var url: String
}
