//
//  ImageCreationRequest.swift
//  
//
//  Created by Nunzio Ricci on 07/03/23.
//

import Foundation

/// This object represent requests images to Dall•E
struct ImageCreationRequest: AIRequest {
    typealias Response = ImageCreationResponse
    static let path: String = "v1/images/generations"
    static let method: String = "POST"
    
    /// A text description of the desired image(s). The maximum length is 1000 characters.
    var description: String
    
    /// The number of images to generate. Must be between 1 and 10.
    var quantity: Int?
    
    /// The size of the generated images.
    var size: ImageSize?
    var format: ImageFormat?
    var user: String?
    
    /// This object represent images creation request to Dall•E
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
            throw ImageCreationError.longDescription(length: description.count)
        }
        if let quantity = quantity {
            guard (1...10).contains(quantity) else {
                throw ImageCreationError.invalidQuantity(quantity: quantity)
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


enum ImageSize: String {
    case small = "256x256"
    case medium = "512x512"
    case big = "1024x1024"
}

enum ImageFormat: String {
    case url = "url"
    case b64 = "b64_json"
}
