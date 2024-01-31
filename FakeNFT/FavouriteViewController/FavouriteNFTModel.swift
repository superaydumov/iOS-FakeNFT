import Foundation

struct FavoriteNFTViewModel: Decodable, Encodable {
    let images: [URL]?
    let name: String
    let rating: Int
    let price: Double
    var isFavorite: Bool?
    let id: String

    init(images: [URL], name: String, rating: Int, price: Double, isFavorite: Bool, id: String) {
        self.images = images
        self.name = name
        self.rating = rating
        self.price = price
        self.isFavorite = isFavorite
        self.id = id
    }
}
