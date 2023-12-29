import UIKit

final class NFTRatingController: UIStackView {
    
    private var starsRating = 0
    
    init(starsRating: Int = 0) {
        super.init(frame: .zero)
        self.starsRating = starsRating
        
        var starTag = 1
        for _ in 0..<starsRating {
            let imageView = UIImageView()
            imageView.image = UIImage(named:"noActive")
            imageView.tag = starTag
            self.addArrangedSubview(imageView)
            starTag += 1
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStarsRating(rating: Int) {
        self.starsRating = rating
        let stackSubViews = self.subviews
        for subView in stackSubViews {
            if let image = subView as? UIImageView {
                if image.tag > starsRating {
                    image.image = UIImage(named:"noActive")
                } else {
                    image.image = UIImage(named:"activeStars")
                }
            }
        }
    }
}
