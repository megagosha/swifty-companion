//
//  UserViewModel.swift
//  SwiftyCompanion
//
//  Created by George Tevosov on 23.05.2022.
//

import Foundation
import UIKit


class UserViewModel {
    public var user: User
    public var data: [Int:[ProjectInfo]] = [:]
    public var cursus_ix: Int
    public var img: UIImageView?
    
    init(user: User){
        self.user = user
        self.cursus_ix = 0
        self.prepareData()
        self.findLatestCursus()
        print(cursus_ix)
        print(data)
    }
    
    public func loadImg(finished: () -> ()) {
        var img =  UIImageView()
        
        img.translatesAutoresizingMaskIntoConstraints = false
        let url = URL(string: self.user.url ?? "https://profile.intra.42.fr/images/default.png")
        if url == nil {
            self.img = img
            return
        }
        img.load(url: url!)
        self.img = img
        finished()
    }
    
    public func findLatestCursus() {
        var cur_date = Date(timeIntervalSince1970: 0)
        var ix = 0
        var i = 0
        for cursus in self.user.cursus_users {
            let cursus_date = convertStringToDate(date: cursus.begin_at)
            if (cursus_date != nil && cursus_date! > cur_date) {
                cur_date = cursus_date!
                ix = i
            }
            i += 1
        }
        self.cursus_ix = ix
    }
    
    public func prepareData() {
        for (key, cursus) in self.user.cursus_users.enumerated() {
            data[key] = []
            for project in self.user.projects_users {
                for id in project.cursus_ids {
                    if (id == cursus.cursus_id) {
                        data[key]?.append(project)
                    }
                }
            }
        }
        return
    }
}


func convertStringToDate(date: String)->Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return dateFormatter.date(from: date)
}
