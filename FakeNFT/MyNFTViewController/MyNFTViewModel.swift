
import Foundation

struct MyNFTViewModel:  Decodable, Encodable {
    let images: [URL]?
    let name: String
    let rating: Int
    let author: URL
    let price: Double
    let isFavorite: Bool?
    let id: String
    
    init(images: [URL], name: String, rating: Int, author: URL, price: Double, isFavorite: Bool, id: String) {
        self.images = images
        self.name = name
        self.rating = rating
        self.author = author
        self.price = price
        self.isFavorite = isFavorite
        self.id = id
    }
}
