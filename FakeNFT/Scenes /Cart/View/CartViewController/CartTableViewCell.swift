import UIKit
import Kingfisher

final class CartTableViewCell: UITableViewCell {

    // MARK: - Stored Properties

    static let reuseIndentifier = "cartTableViewCell"
    weak var delegate: CartTableViewCellDelegate?
    var cellIndex: Int?

    // MARK: - Computed Properties

    var imageURL: URL? {
        didSet {
            guard let url = imageURL else {
                return pictureImageView.kf.cancelDownloadTask()
            }
            pictureImageView.kf.setImage(with: url)
        }
    }

    private lazy var pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true

        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .nftBlack
        label.textAlignment = .left

        return label
    }()

    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2

        return stackView
    }()

    private lazy var priceNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .nftBlack
        label.textAlignment = .left
        label.text = "Цена"

        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .nftBlack
        label.textAlignment = .left

        return label
    }()

    private lazy var deleteFromCartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "deleteFromBasket"), for: .normal)
        button.addTarget(nil, action: #selector(deleteFromCartButtonDidTap), for: .touchUpInside)

        return button
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .nftWhite
        self.selectionStyle = .none

        addSubviews()
        constraintsSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        pictureImageView.kf.cancelDownloadTask()
    }

    // MARK: - Private methods

    private func addSubviews() {
        [pictureImageView,
         nameLabel,
         ratingStackView,
         priceNameLabel,
         priceLabel,
         deleteFromCartButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
    }

    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            pictureImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            pictureImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            pictureImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            pictureImageView.heightAnchor.constraint(equalToConstant: 108),
            pictureImageView.widthAnchor.constraint(equalToConstant: 108),

            nameLabel.leadingAnchor.constraint(equalTo: pictureImageView.trailingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: pictureImageView.topAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            ratingStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingStackView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            priceNameLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 12),
            priceNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            priceLabel.topAnchor.constraint(equalTo: priceNameLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: priceNameLabel.leadingAnchor),

            deleteFromCartButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteFromCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            deleteFromCartButton.heightAnchor.constraint(equalToConstant: 40),
            deleteFromCartButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configureCell(with nft: CartNFTModel) {
        imageURL = nft.images.first
        nameLabel.text = nft.name
        priceLabel.text = "\(nft.price)" + " ETH"

        for subView in ratingStackView.arrangedSubviews {
            subView.removeFromSuperview()
        }

        let roundedRating = Int(round(Double(nft.rating/2)))
        for _ in 0..<min(roundedRating, 5) {
            let starImageView = UIImageView(image: UIImage(named: "filledStar"))
            ratingStackView.addArrangedSubview(starImageView)
            starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        }

        for _ in min(roundedRating, 5)..<5 {
            let starImageView = UIImageView(image: UIImage(named: "star"))
            ratingStackView.addArrangedSubview(starImageView)
            starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        }
    }

    // MARK: - Handlers

    @objc func deleteFromCartButtonDidTap() {
        guard let cellIndex,
              let cellImage = pictureImageView.image
        else { return }
        delegate?.showDeleteViewController(for: cellIndex, with: cellImage)
    }
}
