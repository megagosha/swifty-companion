//
//  MainViewModel.swift
//  SwiftyCompanion
//
//  Created by George Tevosov on 18.05.2022.
//

import Foundation
import AuthenticationServices

class SearchViewModel {
    
    let defaults = UserDefaults.standard
    
    var ready: Bool = false
    
    var user: User?
    
    var token: String?
    
    var expires_at: UInt?
    
    init() {
        let token = defaults.string(forKey:"token")
        let expires_at = defaults.integer(forKey: "expires_at")
        if (token == nil || !tokenIsValid(expires_at: UInt(expires_at))) {
            self.updateCredentials()
        }
        else
        {
            self.token = token
            self.expires_at = UInt(expires_at)
        }
    }
    
    func tokenIsValid(expires_at: UInt?)->Bool {
        return self.token != nil && expires_at != nil && expires_at! > Date.currentTimestamp()
    }
    
    func updateCredentials(force: Bool = false) {
        guard (!tokenIsValid(expires_at: self.expires_at) && !force) else {
            return
        }
        self.getCredentials(completion: { cred in
            if (cred == nil)
            {
                print("ERROR")
                return
            }
            let expires_at = cred!.expires_in + cred!.created_at
            self.defaults.set(expires_at, forKey: "expires_at")
            self.defaults.set(cred?.access_token, forKey: "token")
            self.token = cred?.access_token
            self.expires_at = expires_at
        })
    }
    
    
    func getCredentials(completion:@escaping (Credentials?) -> ()) {
        let uid = "8dd4286cd4b791302978ec923d8fb4a1b5c236bf617a32310498042221581752"
        let secret = "4785a92792ce3254b85a9c0cc4026648c141742229b4efa350e9a4fee916d21e"
        guard let authURL = URL(string: "https://api.intra.42.fr/oauth/token?grant_type=client_credentials&client_id=" + uid + "&client_secret=" + secret) else {
            print("error")
            return }
        var req = URLRequest(url: authURL)
        req.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            do {
                //                let outputStr  = String(data: data!, encoding: String.Encoding.utf8) as String?
                //                _                     print(outputStr!)
                if error != nil {
                    self.handleError(error: NSError())
                    completion(nil)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    self.handleError(error: NSError(domain:"", code: 500, userInfo:nil))
                    completion(nil)
                    return
                }
                if (data == nil)
                {
                    self.handleError(error: NSError(domain: "", code: 500, userInfo: nil))
                    completion(nil)
                    return
                }
                let cred =  try JSONDecoder().decode(Credentials.self, from: data!)
                DispatchQueue.main.async {
                    completion(cred)
                }
            }
            catch let error {
                self.handleError(error: NSError(domain:"", code: 500, userInfo:nil))
                print (error)
            }
        }.resume()
    }
    
    func getUser(userInput: String, completion: @escaping (User?) -> ()) {
        var user = userInput.trimingTrailingSpaces()
        user = user.lowercased()
        updateCredentials()
        guard (self.token != nil && !user.isEmpty) else {
            completion(nil)
            return
        }
        let url = URL(string: "https://api.intra.42.fr/v2/users/" + user)
        if (url == nil) {
            print ("Invalid url...")
            completion(nil)
            return
        }
        var req = URLRequest(url: url!)
        req.setValue("Bearer " + self.token!, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: req) { data, response, error in
            do {
                //                let outputStr  = String(data: data!, encoding: String.Encoding.utf8) as String?
                if let error = error {
                    self.handleError(error: NSError(domain: error.localizedDescription, code: 500))
                    completion(nil)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    let httpResponse = response as? HTTPURLResponse
                    if (httpResponse != nil && httpResponse?.statusCode == 401)
                    {
                        self.updateCredentials()
                        self.handleError(error: NSError(domain:"", code: 401, userInfo:nil))
                    }
                    self.handleError(error: NSError(domain:"", code: 500, userInfo:nil))
                    completion(nil)
                    return
                }
                if (data == nil)
                {
                    self.handleError(error: NSError(domain: "", code: 500, userInfo: nil))
                    completion(nil)
                    return
                }
                let user =  try JSONDecoder().decode(User.self, from: data!)
                DispatchQueue.main.async {
                    
                    completion(user)
                }
            }
            catch let error {
                self.handleError(error: NSError(domain:"", code: 500, userInfo:nil))
                print (error)
            }
        }.resume()
    }
    
    
    func handleError(error: NSError) {
        if (error.code == 401) {
            print("show alert on 401")
        }
        print("retry")
    }
}

extension Date {
    static func currentTimestamp() -> Int {
        return Int(Date().timeIntervalSince1970)
    }
}
extension String {
    func trimingTrailingSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        guard let index = lastIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: characterSet) }) else {
            return self
        }
        
        return String(self[...index])
    }
}

