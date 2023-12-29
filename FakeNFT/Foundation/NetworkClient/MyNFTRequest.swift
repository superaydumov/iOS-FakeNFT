import Foundation

struct MyNFTRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft")
    }
    
    var httpMethod: HttpMethod {
        return .get
    }
}

struct PutMyNFTRequest: NetworkRequest {
    var updatedProfile: Profile
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft")
    }
    
    var httpMethod =  HttpMethod.put
    
    var httpBody: Data? {
        try? JSONEncoder().encode(updatedProfile)
    }
}
