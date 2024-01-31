import UIKit

struct CurrencyNetworkModel: Codable {
    let title: String
    let name: String
    let image: URL?
    let id: String
}

struct CurrencyResultModel {
    let title: String
    let name: String
    let image: URL?
    let id: String
}
