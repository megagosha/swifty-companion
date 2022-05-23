//
//  Project.swift
//  SwiftyCompanion
//
//  Created by George Tevosov on 23.05.2022.
//

import Foundation

struct Project: Codable {
    let id: Int
    let name: String
    let parent_id: Int?
}
