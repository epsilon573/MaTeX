//
//  ChatGptResponse.swift
//  Matex
//
//  Created by Sahil Sharma on 07/04/23.
//

import Foundation

struct ChatGptResponse : Codable {
    let id: String
    let choices: [Choice]
}

struct Choice : Codable {
    let index: Int
    let message: Message
}
