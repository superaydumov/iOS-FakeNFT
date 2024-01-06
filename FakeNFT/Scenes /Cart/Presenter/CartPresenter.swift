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
    
    private func putCartOrder(id: String, nfts: [String], completion: @escaping (Result<CartOrderUpdateModel, Error>) -> Void) {
        let request = CartPutOrderRequest(updateModel: CartOrderUpdateModel(id: id, nfts: nfts))
        let networkClient = DefaultNetworkClient()
        
        networkClient.send(request: request, type: CartOrderUpdateModel.self, completionQueue: .main, onResponse: completion)
    }
    
    private func toogleCartOrder() {
        self.cartViewController?.setLoaderIsHidden(false)
        
        var nftArray = [String]()
        visibleNFT.forEach { nft in
            if !nftArray.contains(nft.id) {
                nftArray.append(nft.id)
            }
        }
        
        putCartOrder(id: "1", nfts: nftArray) { result in
            switch result {
            case .success(let data):
                print("Server nfts: \(data.nfts)")
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
        self.cartViewController?.setLoaderIsHidden(true)
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
        toogleCartOrder()
    }
    
    func addItemToCart(_ nft: CartNFTModel) {
        visibleNFT.append(nft)
        toogleCartOrder()
    }
    
    func cleanCart() {
        visibleNFT.removeAll()
        toogleCartOrder()
    }
    
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
                cartNFTNetworkModel.nfts.forEach { [weak self] nftID in
                    guard let self else { return }
                    
                    if self.visibleNFT.contains(where: { $0.id == nftID }) {
                        return
                    }
                    
                    self.loadNFT(id: nftID) { [weak self] nftResult in
                        guard let self else { return } 
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
