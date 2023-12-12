//
//  UserModel.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 10.12.23.
//

//import Foundation
//
//struct UserModel: Decodable {
//    var avatar: String
//    var username: String
//    var nftCount: String
//
//    private enum CodingKeys: String, CodingKey {
//        case avatar
//        case username
//        case nftCount
//    }
//
//    init(avatar: String, username: String, nftCount: String) {
//        self.avatar = avatar
//        self.username = username
//        self.nftCount = nftCount
//    }
//
////    func decodeAvatar() -> UIImage? {                 //если вернут base64
////        // Удаляем префикс, если он присутствует
////        var cleanedBase64 = avatarBase64
////        if cleanedBase64.hasPrefix("data:") {
////            if let commaRange = cleanedBase64.range(of: ",") {
////                cleanedBase64 = String(cleanedBase64[commaRange.upperBound...])
////            }
////        }
////
////        // Проверяем, что строка Base64 не пуста
////        guard !cleanedBase64.isEmpty else {
////            print("Base64 string is empty")
////            return nil
////        }
////
////        // Декодируем строку Base64 в объект Data
////        guard let data = Data(base64Encoded: cleanedBase64) else {
////            print("Error decoding Base64 string")
////            return nil
////        }
////
////        // Создаем объект UIImage из данных
////        guard let image = UIImage(data: data) else {
////            print("Error creating UIImage from data")
////            return nil
////        }
////
////        return image
////    }
//}

import Foundation

struct UserModel: Decodable {
    var avatar: String?
    var username: String?
    var nftCount: String?
    var description: String?
    var website: String?
    var rating: String?

    private enum CodingKeys: String, CodingKey {
        case avatar
        case username
        case nftCount
        case description
        case website
        case rating
    }

    init(avatar: String?, username: String?, nftCount: String?, description: String?, website: String?, rating: String?) {
        self.avatar = avatar
        self.username = username
        self.nftCount = nftCount
        self.description = description
        self.website = website
        self.rating = rating
    }
}

