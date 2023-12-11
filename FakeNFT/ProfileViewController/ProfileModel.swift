import UIKit

protocol ProfileModel {
    var name: String { get set }
    var bio: String { get set }
    var link: String { get set }
    var avatarImage: UIImage { get }
    var cellTexts: [String] { get }
}

struct ProfileModelImpl: ProfileModel {
    var name: String = "Joaquin Phoenix"
    var bio: String = "Дизайнер из Казани, люблю цифровое искусство\nи бейглы. В моей коллекции уже 100+ NFT,\nи еще больше — на моём сайте. Открыт\nк коллаборациям."
    var link: String = "JoaquinPhoenix.com"
    var avatarImage: UIImage = UIImage(named: "avatar") ?? UIImage()
    var cellTexts: [String] = ["Мои NFT", "Избранные NFT", "О разработчике"]
}
