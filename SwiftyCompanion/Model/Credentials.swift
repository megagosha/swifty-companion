//
//  Cred.swift
//  SwiftyCompanion
//
//  Created by George Tevosov on 19.05.2022.
//

import Foundation


struct Credentials: Codable {
    let access_token: String
    let token_type: String
    let expires_in: UInt
    let scope: String
    let created_at: UInt
}
