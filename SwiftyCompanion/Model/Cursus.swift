//
//  Cursus.swift
//  SwiftyCompanion
//
//  Created by George Tevosov on 23.05.2022.
//

import Foundation

struct Cursus: Codable {
    let cursus_id: Int
    let grade: String?
    let level: Float
    var skills: [Skill]
    let begin_at: String
    let cursus: CursusBasic
}
