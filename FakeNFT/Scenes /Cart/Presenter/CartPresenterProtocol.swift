import Foundation

protocol CartPresenterProtocol: AnyObject {
    var visibleNFT: [CartNFTModel] { get }
    var currencyArray: [CurrencyResultModel] { get }
    
    func sortByPrice()
    func sortByRating()
    func sortByName()
    func deleteItemFormCart(for index: Int)
    func cleanCart()
    func fetchCurrencies()
}
