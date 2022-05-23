//
//  UserModel.swift
//  SwiftyCompanion
//
//  Created by George Tevosov on 18.05.2022.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let email: String?
    let login: String
    let first_name: String?
    let last_name: String?
    let url: String?
    let phone: String?
    let displayname: String?
    let image_url: String?
    let staff: Bool?
    let correction_point: Int?
    let pool_month: String?
    let pool_year: String?
    let wallet: Int?
    let cursus_users: [Cursus]
    let projects_users: [ProjectInfo]
    
}

struct Cursus: Codable {
    let cursus_id: Int
    let grade: String?
    let level: Float
    let skills: [Skill]
    let begin_at: String
    let cursus: CursusBasic
   
    
}
struct CursusBasic: Codable {
    let id: Int
    let name: String
    let slug: String
}


struct Skill: Codable {
    let id: Int
    let name: String
    let level: Float
}

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

struct Project: Codable {
    let id: Int
    let name: String
    let parent_id: Int?
}
