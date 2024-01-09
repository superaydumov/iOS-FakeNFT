import Foundation

struct CartPutOrderRequest: NetworkRequest {

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var httpMethod: HttpMethod {
        .put
    }
    
    var dto: Encodable?
    var body: Data?

    init(updateModel: CartOrderUpdateModel) {
        var nfts = ""
        updateModel.nfts.enumerated().forEach { (index, nft) in
            nfts += "nfts=\(nft)&"
        }
        nfts += "id=\(updateModel.id)"
        let dataString = nfts
        self.body = dataString.data(using: .utf8)
        let orderToPut = CartOrderUpdateModel(id: updateModel.id, nfts: updateModel.nfts)
        self.dto = orderToPut
    }
}
