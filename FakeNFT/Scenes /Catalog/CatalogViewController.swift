import UIKit

final class CatalogViewController: UIViewController {

    private var sourceArray = CartMockData.mockNFT
    weak var delegate: CartViewControllerDelegate?

    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("NFT", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.nftWhite, for: .normal)
        button.backgroundColor = .nftBlack
        button.layer.cornerRadius = 16
        button.addTarget(nil, action: #selector(buttonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .nftWhite

        addSubviews()
        constraintsSetup()
    }

    private func addSubviews() {
        view.addSubview(button)
    }

    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc func buttonDidTap() {
        if let item = sourceArray.randomElement() {
            delegate?.addItemToCart(item)
        }
    }
}
