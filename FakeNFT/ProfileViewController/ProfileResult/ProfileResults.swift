import Foundation

// MARK: - ProfileResult
struct ProfileResults: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [Nft]
    let likes: [String]
    let id: String
}

typealias ProfileList = [ProfileResults]
