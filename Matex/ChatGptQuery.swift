//
//  ChatGptQuery.swift
//  Matex
//
//  Created by Sahil Sharma on 07/04/23.
//

import Foundation

struct ChatGptQuery : Codable {
    var model: String = "gpt-3.5-turbo"
    let messages: [Message]
}

struct Message: Codable {
    let role: String
    let content: String
}
