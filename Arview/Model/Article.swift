//
//  Article.swift
//  Arview
//
//  Created by Zakirov Tahir on 25.04.2021.
//

import Foundation

// MARK: - Article
struct Articles: Decodable {
    let total: Int?
    let top: [Top]?
}

// MARK: - Top
struct Top: Decodable {
    let game: Game?
    let viewers: Int?
    let channels: Int?
}

// MARK: - Game
struct Game: Decodable {
    let name: String?
    let box: Box?
}

// MARK: - Box
struct Box: Decodable {
    let medium: String?
}

