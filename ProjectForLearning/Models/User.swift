//
//  User.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 1.02.23.
//

import SwiftUI
import FirebaseAuth

extension User {
    static var emptyUser = User()
}

struct User: Codable {
    var userId: String = UUID().uuidString
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var bio: String = ""
    var url: URL?
    var imageData: Data?
    
    var isEmptyUser: Bool {
        self.userId == Self.emptyUser.userId
    }
        
    var image: UIImage? {
        get {
            if let imageData = imageData {
                return UIImage(data: imageData)
            } else {
                return nil
            }
        }
        set {
            imageData = newValue?.jpegData(compressionQuality: 1.0)
        }
    }
    
//    var displayName: String? {
//        get {
//            return firstName.capitalized + " " + lastName.capitalized
//        }
//        set {
//            if let array = newValue?.components(separatedBy: " ") {
//                if array.count == 1 {
//                    firstName = array[0]
//                } else {
//                    firstName = array[0]
//                    lastName = array[1]
//                }
//            }
//        }
//    }
    
    init() {
        
    }
    
    init(userId: String, email: String?, displayName: String?, phoneNumber: String?, url: URL?) {
        self.userId = userId
        
        if let email {
            self.email = email
        }
        
        if let displayName {
            let array = displayName.components(separatedBy: " ")
            
            if array.count == 1 {
                firstName = array[0]
            } else {
                firstName = array[0]
                lastName = array[1]
            }
        }
        
        if let phoneNumber = phoneNumber {
            self.phoneNumber = phoneNumber
        }
        self.url = url
    }
        
    static func restoreUser(userId: String) throws -> User? {
        guard let data = UserDefaults.standard.data(forKey: userId) else {
            return nil
        }
        
        return try JSONDecoder().decode(User.self, from: data)
    }
    
    func saveUserData() throws {
        let user = try JSONEncoder().encode(self)
        UserDefaults.standard.set(user, forKey: userId)
    }
}
