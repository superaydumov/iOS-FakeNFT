import UIKit

final class FavouriteButton: UIButton {
    var nftID: String?
    var isFavorite: Bool = false {
        didSet {
            let image = self.isFavorite ? UIImage(named: "activeHeart") : UIImage(named: "noActiveHeart")
            setImage(image, for: .normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
