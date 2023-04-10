//
//  PdfData.swift
//  Matex
//
//  Created by Sahil Sharma on 09/04/23.
//

import Foundation

struct PdfData : Codable {
    let title: String
    let subtitle: String
    let author: String
    let date: String
    let horizontalMargin: String
    let verticalMargin: String
    let fontsize: String
    let colorlinks: Bool
    let isTocEnabled: Bool
    let content: String
    let filename: String
}
