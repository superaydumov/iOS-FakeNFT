import Foundation

protocol CartViewControllerDelegate: AnyObject {
    func addItemToCart(_ nft: CartNFTModel)
}
