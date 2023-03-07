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
    var data: [ImageCreationRequestData]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.created = try container.decode(Int.self, forKey: .created)
        self.data = try container.decode([ImageCreationRequestData].self, forKey: .data)
    }
    
    enum CodingKeys: String, CodingKey {
        case created
        case data
    }
}

struct ImageCreationRequestData: Decodable {
    var url: String?
    var b64_json: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let url = try? container.decodeIfPresent(String.self, forKey: .url) {
            self.url = url
        } else if let b64_json = try? container.decodeIfPresent(String.self, forKey: .b64_json) {
            self.b64_json = b64_json
        } else {
            throw ImageCreationError.invalidResoponseFormat
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case url
        case b64_json
    }
}
