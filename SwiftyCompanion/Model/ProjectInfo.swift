//
//  ProjectInfo.swift
//  SwiftyCompanion
//
//  Created by George Tevosov on 23.05.2022.
//

import Foundation

struct ProjectInfo: Codable, Identifiable {
    let id: Int
    let status: String
    let validated: Bool?
    let final_mark: Int?
    let project: Project
    let marked: Bool
    let marked_at: String?
    let cursus_ids: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id
        case status
        case final_mark
        case project
        case marked
        case marked_at
        case validated = "validated?"
        case cursus_ids
    }
}
