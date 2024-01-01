import UIKit

struct CartNFTNetworkModel: Codable {
    let id: String
    let name: String
    let images: [URL]
    let rating: Int
    let price: Float
}
