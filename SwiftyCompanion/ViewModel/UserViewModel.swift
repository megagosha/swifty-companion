//
//  UserViewModel.swift
//  SwiftyCompanion
//
//  Created by George Tevosov on 23.05.2022.
//

import Foundation
import UIKit
import CloudKit


class UserViewModel {
    
    public var user: User
    
    public var data: [Int:[ProjectInfo]] = [:]
    
    public var cursus_ix: Int
    
    public var key_cursus: [String: Int] = [:]
    
    public var img: UIImageView?
    
    public func loadImg(finished: () -> ()) {
        let img =  UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        img.layer.cornerRadius = 150 / 2
        let url = URL(string: self.user.image_url ?? "https://profile.intra.42.fr/images/default.png")
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
            self.key_cursus[cursus.cursus.name] = key
            data[key] = data[key]?.sorted(by: {$0.project.name < $1.project.name})
            self.user.cursus_users[key].skills = self.user.cursus_users[key].skills.sorted(by: {$0.level > $1.level})
        }
        return
    }
    
    public func getSkillRow(ix: Int)->(name: String, lvl: String) {
        let lvl = user.cursus_users[cursus_ix].skills[ix].level
        let rounded = String(format: "%.2f", lvl)
        
        return (user.cursus_users[cursus_ix].skills[ix].name ,
                lvl: rounded)
    }
    
    public func getProjectStatus(ix: Int)->Bool {
        return (data[cursus_ix]![ix].validated != nil &&
                data[cursus_ix]![ix].validated!)
    }
    
    public func getSkillsCount()->Int {
        return user.cursus_users[cursus_ix].skills.count
    }
    
    public func getProjectsCount()->Int {
        return data[cursus_ix]!.count
    }
    
    
    public func getProjectCellData(ix: Int)->(name: String, result: Int?, complete: Bool) {
        return (name: data[cursus_ix]![ix].project.name,
                result: data[cursus_ix]![ix].final_mark, complete: getProjectStatus(ix: ix))
    }
    
    init(user: User){
        self.user = user
        self.cursus_ix = 0
        self.prepareData()
        self.findLatestCursus()
    }
}

func convertStringToDate(date: String)->Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return dateFormatter.date(from: date)
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
                print("failed to create UIIMage")
            }
            else
            {
                print("img download failed")
            }
        }
    }
}
