import Foundation

struct ProfileModelImpl: Decodable {
    var name: String?
    var description: String?
    var website: String?
    var avatarImage: String?
    var nfts: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case website
        case avatarImage
        case nfts
    }
    
    init(name: String?, description: String?, website: String?, avatarImage: String?, nfts: [String]) {
        self.name = name
        self.description = description
        self.website = website
        self.avatarImage = avatarImage
        self.nfts = nfts
    }
}
