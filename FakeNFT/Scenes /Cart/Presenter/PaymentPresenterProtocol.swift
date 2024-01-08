import Foundation

protocol PaymentPresenterProtocol: AnyObject {
    var currencyArray: [CurrencyResultModel] { get }
    
    func fetchCurrencies()
}
