//
//  File.swift
//  
//
//  Created by Nunzio Ricci on 07/03/23.
//

import Foundation

enum ImageCreationError: Error {
    case longDescription(length: Int)
    case invalidQuantity(quantity: Int)
}
