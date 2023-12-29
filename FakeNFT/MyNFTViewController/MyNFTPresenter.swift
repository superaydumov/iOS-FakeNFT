import Foundation

protocol MyNFTPresenterProtocol: AnyObject {
    func viewDidLoad()
}

final class MyNFTPresenter: MyNFTPresenterProtocol {
    private var onNFTCountUpdate: ((Int) -> Void)?
    private weak var view: MyNFTViewProtocol?
    var defaultNetworkClient = DefaultNetworkClient()
    
    init(view: MyNFTViewProtocol) {
        self.view = view
    }
    
    init(onNFTCountUpdate: ((Int) -> Void)?) {
        self.onNFTCountUpdate = onNFTCountUpdate
    }
    
    func viewDidLoad() {
        // замоканные данные вместо загрузки из сети
        let mockNFTs = createMockNFTs()
        let nftCount = mockNFTs.count
        onNFTCountUpdate?(nftCount)
        view?.updateNFT(viewModel: mockNFTs)
    }
    
    private func createMockNFTs() -> [MyNFTViewModel] {
        let mockNFT1 = MyNFTViewModel(images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")!],
                                      name: "Lilo",
                                      rating: 3,
                                      author: URL(string:"https://condescending_almeida.fakenfts.org/")!,
                                      price: 10.99,
                                      isFavorite: true,
                                      id: "739e293c-1067-43e5-8f1d-4377e744ddde")
        
        let mockNFT2 = MyNFTViewModel(images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")!],
                                      name: "Spring",
                                      rating: 3,
                                      author: URL(string:"https://dazzling_meninsky.fakenfts.org/")!,
                                      price: 15.99,
                                      isFavorite: false,
                                      id: "77c9aa30-f07a-4bed-886b-dd41051fade2")
        
        let mockNFT3 = MyNFTViewModel(images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")!],
                                      name: "Aprill",
                                      rating: 4,
                                      author: URL(string:"https://hungry_darwin.fakenfts.org/")!,
                                      price: 18.99,
                                      isFavorite: true,
                                      id: "ca34d35a-4507-47d9-9312-5ea7053994c0")
        
        return [mockNFT1, mockNFT2, mockNFT3]
    }
}
