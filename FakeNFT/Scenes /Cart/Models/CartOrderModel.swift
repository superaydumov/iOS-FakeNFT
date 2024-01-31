import Foundation

struct CartOrderNetworkModel: Codable {
    let id: String
    let nfts: [String]
}

struct CartOrderUpdateModel: Codable {
    let id: String
    let nfts: [String]
}
