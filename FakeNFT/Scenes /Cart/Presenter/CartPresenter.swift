import UIKit

final class CartPresenter: CartPresenterProtocol {
    
    // MARK: - Stored Properties
    
    var visibleNFT: [CartNFTModel] = CartMockData.mockNFT {
        didSet {
            cartViewController?.tableViewUpdate()
        }
    }
    
    var currencyArray = [CurrencyResultModel]() {
        didSet {
            paymentViewController?.collectionViewUpdate()
        }
    }
    
    private weak var cartViewController: CartViewControllerProtocol?
    private weak var paymentViewController: PaymentTypeViewControllerProtocol?
    
    init(
        cartViewController: CartViewControllerProtocol?,
        paymentViewController: PaymentTypeViewControllerProtocol?
    ) {
        self.cartViewController = cartViewController
        self.paymentViewController = paymentViewController
    }
    
    // MARK: - Private methods
    
    private func loadCurrencies(completion: @escaping (Result<[CurrencyNetworkModel], Error>) -> Void) {
        let request = CurrencyRequest()
        let networkClient = DefaultNetworkClient()
        
        networkClient.send(request: request, type: [CurrencyNetworkModel].self, completionQueue: .main, onResponse: completion)
    }
    
    // MARK: - Public methods
    
    func sortByPrice() {
        visibleNFT.sort { $0.price > $1.price }
        UserDefaults.standard.set(true, forKey: "sortByPrice")
        UserDefaults.standard.removeObject(forKey: "sortByRating")
        UserDefaults.standard.removeObject(forKey: "sortByName")
    }
    
    func sortByRating() {
        visibleNFT.sort { $0.rating > $1.rating }
        UserDefaults.standard.set(true, forKey: "sortByRating")
        UserDefaults.standard.removeObject(forKey: "sortByPrice")
        UserDefaults.standard.removeObject(forKey: "sortByName")
    }
    
    func sortByName() {
        visibleNFT.sort { $0.name < $1.name }
        UserDefaults.standard.set(true, forKey: "sortByName")
        UserDefaults.standard.removeObject(forKey: "sortByPrice")
        UserDefaults.standard.removeObject(forKey: "sortByRating")
    }
    
    func deleteItemFormCart(for index: Int) {
        visibleNFT.remove(at: index)
    }
    
    func addItemToCart(_ nft: CartNFTModel) {
        visibleNFT.append(nft)
    }
    
    func cleanCart() {
        visibleNFT.removeAll()
    }
    
    func fetchCurrencies() {
        self.paymentViewController?.setLoaderIsHidden(false)
        loadCurrencies { result in
            switch result {
            case .success(let currencyNetworkModel):
                currencyNetworkModel.forEach { currency in
                    let loadedCurrency = CurrencyResultModel(
                        title: currency.title,
                        name: currency.name,
                        image: currency.image,
                        id: currency.id)
                    self.currencyArray.append(loadedCurrency)
                    
                    if self.currencyArray.count == currencyNetworkModel.count {
                        self.paymentViewController?.setLoaderIsHidden(true)
                    }
                }
            case .failure(let error):
                assertionFailure(error.localizedDescription)
                self.paymentViewController?.setLoaderIsHidden(true)
            }
        }
    }
}
