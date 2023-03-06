//
//  Image.swift
//  
//
//  Created by Nunzio Ricci on 04/02/23.
//

import Foundation

/// This object represent requests images to Dall•E
struct ImageRequest: AIRequest {
    typealias Response = ImageResponse
    static let path: String = "v1/images/generations"
    static let method: String = "POST"
    
    var description: String
    var quantity: Int?
    var size: ImageSize?
    var format: ImageFormat?
    var user: String?
    
    /// This object represent requests images to Dall•E
    ///
    /// - Parameters:
    ///   - description: A text description of the desired image(s). The maximum length is 1000 characters.
    ///   - quantity: The number of images to generate. Must be between 1 and 10.
    ///   - size: The size of the generated images.
    ///   - format: The format in which the generated images are returned.
    ///   - user: A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
    ///
    /// - Throws:
    ///   - `ImageResponseError.longDescription`: if `description` contains more than 1000 characters.
    ///   - `ImageResponseError.invalidQuantity`: if `quantity` is declared and it isn't between 1 and 10.
    init(description: String,
         quantity: Int? = nil,
         size: ImageSize? = nil,
         format: ImageFormat? = nil,
         user: String? = nil) throws {
        guard description.count <= 1000 else {
            throw ImageResponseError.longDescription(length: description.count)
        }
        if let quantity = quantity {
            guard (1...10).contains(quantity) else {
                throw ImageResponseError.invalidQuantity(quantity: quantity)
            }
        }
        self.description = description
        self.quantity = quantity
        self.size = size
        self.format = format
        self.user = user
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description, forKey: .description)
        if let quantity = quantity {
            try container.encode(quantity, forKey: .quantity)
        }
        if let size = size {
            try container.encode(size.rawValue, forKey: .size)
        }
        if let format = format {
            try container.encode(format.rawValue, forKey: .format)
        }
        if let user = user {
            try container.encode(user, forKey: .user)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case description = "prompt"
        case quantity = "n"
        case size = "size"
        case format = "response_format"
        case user = "user"
    }
}

/// This object contains required images from Dall•E
struct ImageResponse: AIResponse {
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

enum ImageSize: String {
    case small = "256x256"
    case medium = "512x512"
    case big = "1024x1024"
}

enum ImageFormat: String {
    case url = "url"
    case b64 = "b64_json"
}

enum ImageResponseError: Error {
    case longDescription(length: Int)
    case invalidQuantity(quantity: Int)
}
