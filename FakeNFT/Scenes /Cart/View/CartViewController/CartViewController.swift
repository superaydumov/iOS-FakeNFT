import UIKit
import ProgressHUD

final class CartViewController: UIViewController, CartViewControllerProtocol {

    // MARK: - Stored Properties

    private var presenter: CartPresenterProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private let refreshControl = UIRefreshControl()
    private var deleteIndex = 0

    // MARK: - Computed Properties

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .nftBlack
        label.textAlignment = .center
        label.text = LocalizedStrings.emptyLabelText

        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseIndentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .nftWhite
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        tableView.refreshControl = self.refreshControl

        return tableView
    }()

    private lazy var paymentLayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .nftLightGray
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        return view
    }()

    private lazy var nftCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 NFT"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .nftBlack
        label.textAlignment = .left

        return label
    }()

    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .nftGreenUniversal
        label.textAlignment = .left

        return label
    }()

    private lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizedStrings.proceedPaymentButtonText, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.nftWhite, for: .normal)
        button.backgroundColor = .nftBlack
        button.layer.cornerRadius = 16
        button.accessibilityIdentifier = "payButton"

        button.addTarget(nil, action: #selector(paymentButtonDidTap), for: .touchUpInside)

        return button
    }()

    // MARK: - Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
        presenter = CartPresenter(cartViewController: self)
        alertPresenter = CartAlertPresenter(delegate: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .nftWhite

        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(externalDeleteButtonTapped),
            name: .catalogItemRemoved,
            object: nil
        )

        addSubviews()
        constraintsSetup()
        navBarSetup()
        labelsUpdate()
        elementsSetup()
        updateSorting()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.fetchCartNFTs()
        elementsSetup()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Private methods

    private func addSubviews() {
        [emptyLabel,
         tableView,
         paymentLayerView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        [nftCountLabel,
         totalPriceLabel,
         paymentButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            paymentLayerView.addSubview($0)
        }
    }

    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            emptyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emptyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            paymentLayerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            paymentLayerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            paymentLayerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            paymentLayerView.heightAnchor.constraint(equalToConstant: 76),

            nftCountLabel.leadingAnchor.constraint(equalTo: paymentLayerView.leadingAnchor, constant: 16),
            nftCountLabel.topAnchor.constraint(equalTo: paymentLayerView.topAnchor, constant: 16),
            nftCountLabel.heightAnchor.constraint(equalToConstant: 20),

            totalPriceLabel.leadingAnchor.constraint(equalTo: nftCountLabel.leadingAnchor),
            totalPriceLabel.topAnchor.constraint(equalTo: nftCountLabel.bottomAnchor, constant: 2),
            totalPriceLabel.heightAnchor.constraint(equalToConstant: 22),

            paymentButton.trailingAnchor.constraint(equalTo: paymentLayerView.trailingAnchor, constant: -16),
            paymentButton.leadingAnchor.constraint(equalTo: totalPriceLabel.trailingAnchor, constant: 24),
            paymentButton.centerYAnchor.constraint(equalTo: paymentLayerView.centerYAnchor),
            paymentButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func navBarSetup() {
        if (navigationController?.navigationBar) != nil {
            let sortButton = UIButton(type: .custom)
            sortButton.setImage(UIImage(named: "sortButton"), for: .normal)
            sortButton.frame = CGRect(x: 0, y: 0, width: 42, height: 42)
            sortButton.addTarget(self, action: #selector(sortButtonDidTap), for: .touchUpInside)

            let imageBarButtonItem = UIBarButtonItem(customView: sortButton)
            self.navigationItem.rightBarButtonItem = imageBarButtonItem
        }
    }

    private func labelsUpdate() {
        guard let presenter else { return }
        nftCountLabel.text = "\(presenter.visibleNFT.count)" + " NFT"

        var totalPrice: Float = 0
        for nft in presenter.visibleNFT {
            totalPrice += nft.price
        }
        let formattedPrice = String(format: "%.2f", totalPrice)
        self.totalPriceLabel.text = formattedPrice + " ETH"
    }

    private func elementsSetup() {
        guard let presenter else { return }
        let nftIsEmpty = presenter.visibleNFT.isEmpty

        emptyLabel.isHidden = !nftIsEmpty
        tableView.isHidden = nftIsEmpty
        paymentLayerView.isHidden = nftIsEmpty
        navigationController?.setNavigationBarHidden(nftIsEmpty, animated: false)
        tabBarController?.tabBar.isHidden = false
    }

    private func updateSorting() {
        guard let presenter else { return }

        if UserDefaults.standard.value(forKey: "sortByPrice") != nil {
            presenter.sortByPrice()
        } else if UserDefaults.standard.value(forKey: "sortByRating") != nil {
            presenter.sortByRating()
        } else if UserDefaults.standard.value(forKey: "sortByName") != nil {
            presenter.sortByName()
        }
    }

    // MARK: - Public methods

    func updateCartElements() {
        elementsSetup()
        labelsUpdate()
        self.tableView.reloadData()
    }

    func setLoaderIsHidden(_ isHidden: Bool) {
        if isHidden {
            ProgressHUD.hideCustomLoader()
        } else {
            ProgressHUD.showCustomLoader()
        }
    }

    func showCartAlert(with error: String) {
        let model = CartAlertModel(
            title: LocalizedStrings.cartErrorAlertTitleText,
            message: error,
            firstButtonText: LocalizedStrings.alertRetryButtonText,
            secondButtontext: LocalizedStrings.alertCancelButtonText,
            firstCompletion: { [weak self] in
                guard let self else { return }
                self.presenter?.fetchCartNFTs()
            }
        )
        alertPresenter?.showCartAlert(with: model)
    }

    // MARK: - Handlers

    @objc private func sortButtonDidTap() {
        guard let presenter else { return }
        let alert = UIAlertController(title: nil, message: LocalizedStrings.sortingText, preferredStyle: .actionSheet)

        let sortByPriceAction = UIAlertAction(title: LocalizedStrings.sortByPriceText, style: .default) { _ in
            presenter.sortByPrice()
        }
        let sortByRatingAction = UIAlertAction(title: LocalizedStrings.sortByRatingText, style: .default) { _ in
            presenter.sortByRating()
        }
        let sortByNameAction = UIAlertAction(title: LocalizedStrings.sortByNameText, style: .default) { _ in
            presenter.sortByName()
        }
        let cancelAction = UIAlertAction(title: LocalizedStrings.closeSortingText, style: .cancel, handler: nil)

        alert.addAction(sortByPriceAction)
        alert.addAction(sortByRatingAction)
        alert.addAction(sortByNameAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }

    @objc private func paymentButtonDidTap() {
        let viewController = PaymentTypeViewController()
        viewController.hidesBottomBarWhenPushed = true
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func refreshTableView() {
        presenter?.fetchCartNFTs()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    @objc private func externalDeleteButtonTapped() {
        presenter?.deleteItemFormCart(for: deleteIndex)
    }
}

    // MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter else { return .zero }
        return presenter.visibleNFT.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIndentifier)
                as? CartTableViewCell,
              let presenter = presenter
        else { return UITableViewCell() }

        let nft = presenter.visibleNFT[indexPath.row]
        cell.configureCell(with: nft)
        cell.cellIndex = indexPath.row
        cell.delegate = self

        if let index = cell.cellIndex {
            deleteIndex = index
        }

        return cell
    }
}

    // MARK: - UITableViewDelegate

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let cell = tableView.cellForRow(at: indexPath) as? CartTableViewCell else { return }
            cell.deleteFromCartButtonDidTap()
        }
    }
}

    // MARK: - CartTableViewCellDelegate

extension CartViewController: CartTableViewCellDelegate {
    func showDeleteViewController(for index: Int, with image: UIImage) {
        let viewController = DeleteFromCartViewController(itemImage: image, itemIndex: index)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        viewController.delegate = self
        present(viewController, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
}

    // MARK: - DeleteFromCartViewControllerDelegate

extension CartViewController: DeleteFromCartViewControllerDelegate {
    func deleteItemFromCart(for index: Int) {
        guard let presenter else { return }
        presenter.deleteItemFormCart(for: index)
        labelsUpdate()
        elementsSetup()

        NotificationCenter.default.post(name: .cartItemRemoved, object: nil)
    }

    func showTabBar() {
        tabBarController?.tabBar.isHidden = false
    }
}

    // MARK: - PaymentTypeViewControllerDelegate

extension CartViewController: PaymentTypeViewControllerDelegate {
    func cleanCart() {
        guard let presenter else { return }
        presenter.cleanCart()
        labelsUpdate()
        elementsSetup()
    }
}

    // MARK: - CartViewControllerDelegate

extension CartViewController: CartViewControllerDelegate {
    func addItemToCart(_ nft: CartNFTModel) {
        guard let presenter else { return }
        presenter.addItemToCart(nft)
    }
}
