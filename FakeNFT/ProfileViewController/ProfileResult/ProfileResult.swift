import Foundation

// MARK: - ProfileResult
struct ProfileResult: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [Nft]
    let likes: [String]
    let id: String
}

typealias ProfileList = [ProfileResult]
