import Foundation

final class PaymentPresenter: PaymentPresenterProtocol {

    // MARK: - Stored Properties

    var currencyArray = [CurrencyResultModel]() {
        didSet {
            paymentViewController?.collectionViewUpdate()
        }
    }

    private weak var paymentViewController: PaymentTypeViewControllerProtocol?

    init(paymentViewController: PaymentTypeViewControllerProtocol?) {
        self.paymentViewController = paymentViewController
    }

    // MARK: - Private methods

    private func loadCurrencies(completion: @escaping (Result<[CurrencyNetworkModel], Error>) -> Void) {
        let request = CurrencyRequest()
        let networkClient = DefaultNetworkClient()

        networkClient.send(request: request,
                           type: [CurrencyNetworkModel].self,
                           completionQueue: .main,
                           onResponse: completion)
    }

    // MARK: - Public methods

    func fetchCurrencies() {
        self.paymentViewController?.setLoaderIsHidden(false)
        loadCurrencies { result in
            switch result {
            case .success(let currencyNetworkModel):
                currencyNetworkModel.forEach { [weak self] currency in
                    guard let self else { return }
                    let loadedCurrency = CurrencyResultModel(
                        title: currency.title,
                        name: currency.name,
                        image: currency.image,
                        id: currency.id)
                    self.currencyArray.append(loadedCurrency)
                }
            case .failure(let error):
                self.paymentViewController?.showPaymentAlert(with: error.localizedDescription)
            }
            self.paymentViewController?.setLoaderIsHidden(true)
        }
    }
}
