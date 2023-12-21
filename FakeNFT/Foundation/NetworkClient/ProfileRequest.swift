import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}

struct PutProfileRequest: NetworkRequest {
    var updatedProfile: Profile
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var httpMethod =  HttpMethod.put

    var httpBody: Data? {
        try? JSONEncoder().encode(updatedProfile)
    }
}
