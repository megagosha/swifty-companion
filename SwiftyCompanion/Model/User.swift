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
