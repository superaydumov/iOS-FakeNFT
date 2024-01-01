import UIKit

final class CartPresenter: CartPresenterProtocol {
    
    // MARK: - Stored Properties
    
    var visibleNFT = [CartNFTModel]() {
        didSet {
            cartViewController?.updateCartElements()
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
    
    private func loadCartOrder(completion: @escaping (Result<CartOrderNetworkModel, Error>) -> Void) {
        let request = CartItemsRequest()
        let networkClient = DefaultNetworkClient()
        
        networkClient.send(request: request, type: CartOrderNetworkModel.self, completionQueue: .main, onResponse: completion)
    }
    
    private func loadNFT(id: String, completion: @escaping (Result<CartNFTNetworkModel, Error>) -> Void) {
        let request = CartNFTRequest(id: id)
        let networkClient = DefaultNetworkClient()
        
        networkClient.send(request: request, type: CartNFTNetworkModel.self, completionQueue: .main, onResponse: completion)
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
                }
                self.paymentViewController?.setLoaderIsHidden(true)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
                self.paymentViewController?.setLoaderIsHidden(true)
            }
        }
    }
    
    func fetchCartNFTs() {
        self.cartViewController?.setLoaderIsHidden(false)
        loadCartOrder { cartResult in
            switch cartResult {
            case .success(let cartNFTNetworkModel):
                cartNFTNetworkModel.nfts.forEach { nftID in
                    self.loadNFT(id: nftID) { nftResult in
                        switch nftResult {
                        case .success(let nft):
                            let loadedNFT = CartNFTModel(
                                id: nft.id,
                                name: nft.name,
                                images: nft.images,
                                rating: nft.rating,
                                price: nft.price
                            )
                            self.visibleNFT.append(loadedNFT)
                        case .failure(let error):
                            assertionFailure(error.localizedDescription)
                            self.cartViewController?.setLoaderIsHidden(true)
                        }
                    }
                }
                self.cartViewController?.setLoaderIsHidden(true)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
                self.cartViewController?.setLoaderIsHidden(true)
            }
        }
    }
}
