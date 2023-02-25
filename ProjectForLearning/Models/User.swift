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

enum UserAvatar {
    case url(URL)
    case image(UIImage)
    case unknown
}

extension User {
    enum CodingKeys: CodingKey {
        case userId, firstName, lastName, email, phoneNumber, bio, url
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(userId, forKey: .userId)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(bio, forKey: .bio)
        try container.encode(url, forKey: .url)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        userId = try container.decode(String.self, forKey: .userId)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        email = try container.decode(String.self, forKey: .email)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        bio = try container.decode(String.self, forKey: .bio)
        url = try container.decode(URL.self, forKey: .url)
    }
}

struct User: Codable {
    var userId: String = UUID().uuidString
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var bio: String = ""
    private var image: UIImage?
    private var url: URL?
    private var urlImage: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("\(self.userId).jpg")
    }
    
    var userAvatar: UserAvatar {
        get {
            if let image = self.image {
                return .image(image)
            } else if let url = self.url {
                return .url(url)
            } else {
                return .unknown
            }
        }
        set {
            switch newValue {
            case .image(let image):
                self.image = image
            case .url(let url):
                self.url = url
            case .unknown: break
            }
        }
    }
    
    var isEmptyUser: Bool {
        self.userId == Self.emptyUser.userId
    }

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
        
        var user = try JSONDecoder().decode(User.self, from: data)
        user.loadImage()
        return user
    }

    func saveUserData() throws {
        let user = try JSONEncoder().encode(self)
        
        UserDefaults.standard.set(user, forKey: userId)
        saveImage()
    }

    mutating func loadImage(){
        if let data = try? Data(contentsOf: urlImage), let loaded = UIImage(data: data) {
            image = loaded
        } else {
            image = nil
        }
    }
    
    func saveImage() {
        if let image = self.image {
            if let data = image.pngData() {
                try? data.write(to: urlImage)
            }
        } else {
            try? FileManager.default.removeItem(at: urlImage)
        }
    }
}
